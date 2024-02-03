module PlutoPlotlyExt
    import PlutoPlotly
    import GeoGrids

    # Load the function for PlutoPlotly
    GeoGrids._plotly_plot_func(::Val{:PlutoPlotly}) = PlutoPlotly.plot
end