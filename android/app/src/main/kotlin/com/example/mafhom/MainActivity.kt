package com.example.mafhom

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.tensorflow.lite.Interpreter
import org.tensorflow.lite.gpu.CompatibilityList
import org.tensorflow.lite.gpu.GpuDelegate
import java.io.File
import java.io.FileInputStream
import java.nio.ByteBuffer
import java.nio.ByteOrder
import java.nio.MappedByteBuffer
import java.nio.channels.FileChannel

// Define OUTPUT_CLASSES_COUNT at the top level
private const val OUTPUT_CLASSES_COUNT = 10 // Adjust based on your model's output classes

class MainActivity : FlutterActivity() {
    private val CHANNEL = "tflite"
    private var interpreter: Interpreter? = null
    private var gpuDelegate: GpuDelegate? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "loadModel" -> {
                    val model = call.argument<String>("model")
                    val labels = call.argument<String>("labels")
                    val numThreads = call.argument<Int>("numThreads") ?: 1
                    val isAsset = call.argument<Boolean>("isAsset") ?: true
                    val useGpuDelegate = call.argument<Boolean>("useGpuDelegate") ?: false
                    loadModel(model, labels, numThreads, isAsset, useGpuDelegate, result)
                }
                "runModelOnFrame" -> {
                    val bytesList = call.argument<List<ByteArray>>("bytesList")
                    val imageHeight = call.argument<Int>("imageHeight") ?: 0
                    val imageWidth = call.argument<Int>("imageWidth") ?: 0
                    runModelOnFrame(bytesList, imageHeight, imageWidth, result)
                }
                "runModelOnBinary" -> {
                    val byteBuffer = call.argument<ByteArray>("byteBuffer")
                    val outputSize = call.argument<Int>("outputSize") ?: 0
                    runModelOnBinary(byteBuffer, outputSize, result)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun loadModel(modelPath: String?, labelsPath: String?, numThreads: Int, isAsset: Boolean, useGpuDelegate: Boolean, result: MethodChannel.Result) {
        try {
            val options = Interpreter.Options().apply {
                setNumThreads(numThreads)
                
                if (useGpuDelegate) {
                    if (CompatibilityList().isDelegateSupportedOnThisDevice) {
                        gpuDelegate = GpuDelegate()
                        addDelegate(gpuDelegate)
                    } else {
                        result.error("GPU_NOT_SUPPORTED", "GPU delegate is not supported on this device", null)
                        return
                    }
                }
            }

            val modelBuffer = loadModelFile(modelPath, isAsset)
            interpreter = Interpreter(modelBuffer, options)
            
            result.success("Model loaded successfully")
        } catch (e: Exception) {
            result.error("MODEL_LOAD_FAILURE", "Failed to load model: ${e.message}", null)
        }
    }

    private fun loadModelFile(modelPath: String?, isAsset: Boolean): MappedByteBuffer {
        if (modelPath == null) {
            throw IllegalArgumentException("Model path cannot be null")
        }

        return if (isAsset) {
            assets.openFd(modelPath).use { fileDescriptor ->
                FileInputStream(fileDescriptor.fileDescriptor).channel.map(
                    FileChannel.MapMode.READ_ONLY,
                    fileDescriptor.startOffset,
                    fileDescriptor.declaredLength
                )
            }
        } else {
            FileInputStream(File(modelPath)).channel.map(
                FileChannel.MapMode.READ_ONLY,
                0,
                File(modelPath).length()
            )
        }
    }

    private fun runModelOnFrame(bytesList: List<ByteArray>?, imageHeight: Int, imageWidth: Int, result: MethodChannel.Result) {
        if (interpreter == null || bytesList == null) {
            result.error("MODEL_NOT_LOADED", "Model is not loaded or bytesList is null", null)
            return
        }

        try {
            val inputBuffer = ByteBuffer.allocateDirect(imageHeight * imageWidth * 3 * 4)
            inputBuffer.order(ByteOrder.nativeOrder())

            for (byteArray in bytesList) {
                inputBuffer.put(byteArray)
            }

            val outputBuffer = Array(1) { FloatArray(OUTPUT_CLASSES_COUNT) }
            interpreter!!.run(inputBuffer, outputBuffer)

            val recognitions = mutableListOf<Map<String, Any>>()
            for (i in outputBuffer[0].indices) {
                val recognition = mapOf(
                    "label" to "Label $i", // Replace with actual label if you have a label list
                    "confidence" to outputBuffer[0][i]
                )
                recognitions.add(recognition)
            }

            result.success(recognitions)
        } catch (e: Exception) {
            result.error("MODEL_RUN_FAILURE", "Failed to run model: ${e.message}", null)
        }
    }

    private fun runModelOnBinary(byteBuffer: ByteArray?, outputSize: Int, result: MethodChannel.Result) {
        if (interpreter == null || byteBuffer == null) {
            result.error("MODEL_NOT_LOADED", "Model is not loaded or byteBuffer is null", null)
            return
        }

        try {
            val inputBuffer = ByteBuffer.allocateDirect(byteBuffer.size)
            inputBuffer.order(ByteOrder.nativeOrder())
            inputBuffer.put(byteBuffer)
            
            val outputBuffer = Array(1) { FloatArray(outputSize) }
            interpreter!!.run(inputBuffer, outputBuffer)

            val recognitions = mutableListOf<Map<String, Any>>()
            for (i in outputBuffer[0].indices) {
                val recognition = mapOf(
                    "label" to "Label $i", // Replace with actual label if you have a label list
                    "confidence" to outputBuffer[0][i]
                )
                recognitions.add(recognition)
            }

            result.success(recognitions)
        } catch (e: Exception) {
            result.error("MODEL_RUN_FAILURE", "Failed to run model on binary: ${e.message}", null)
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        interpreter?.close()
        gpuDelegate?.close()
    }
}
