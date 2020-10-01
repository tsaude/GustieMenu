package com.tuckersaude.gustiemenu

import io.micronaut.runtime.Micronaut

object Application {
    @JvmStatic
    fun main(args: Array<String>) {
        Micronaut.build()
            .packages("com.tuckersaude.gustiemenu")
            .mainClass(Application.javaClass)
            .start()
    }
}