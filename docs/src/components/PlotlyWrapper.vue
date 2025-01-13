<!-- Adapted from https://github.com/boscoh/vue3-plotly-ts -->

<template>
    <div ref="divRef" :id="plotlyId"></div>
</template>

<script setup lang="ts">
import { onBeforeUnmount, ref, watchEffect } from 'vue'
import type { Data, Layout, Config } from 'plotly.js-dist-min'

const props = defineProps<{
    data?: Plotly.Data[]
    layout?: Partial<Plotly.Layout>
    config?: Partial<Plotly.Config>
}>();

const randomString = Math.random().toString(36).slice(2, 7);
const plotlyId = ref<string>(`plotly-${randomString}`);
const divRef = ref<Plotly.PlotlyHTMLElement>();

defineExpose({ plotlyId });

function debounce<Params extends any[]>(
    func: (...args: Params) => any,
    timeout: number
): (...args: Params) => void {
    let timer: NodeJS.Timeout
    return (...args: Params) => {
        clearTimeout(timer)
        timer = setTimeout(() => {
            func(...args)
        }, timeout)
    }
}


if (typeof window !== 'undefined') { // Handle server-side rendering (SSR)
    const Plotly = await import('plotly.js-dist-min');

    let isCreated = false

    function resize() {
        Plotly.Plots.resize(divRef.value as Plotly.Root)
    }

    const resizeObserver = new ResizeObserver(debounce(resize, 50))

    watchEffect(async () => {
        const data = props.data ? props.data : []
        const div = divRef.value as Plotly.Root
        if (isCreated) {
            Plotly.react(div, data, props.layout, props.config)
        } else if (div) {
            await Plotly.newPlot(div, data, props.layout, props.config)
            resizeObserver.observe(div as Plotly.PlotlyHTMLElement)
            isCreated = true
        }
    })

    onBeforeUnmount(() => {
        resizeObserver.disconnect()
        Plotly.purge(divRef.value as Plotly.Root)
    })
}
</script>