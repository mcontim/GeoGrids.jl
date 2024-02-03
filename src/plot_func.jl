# Add method just for export
function plot_unitarysphere end # Define the function without creating any method, as these will be added in the extension
function plot_geo end # Define the function without creating any method, as these will be added in the extension

# Stuff for handling different plotly packages
const PLOTLY_PLOT_FUNC_PRIORITY = [:PlutoPlotly, :PlotlyBase]
_plotly_plot_func(@nospecialize(::Val)) = nothing
function _plotly_plot(args...;kwargs...)
    for key in PLOTLY_PLOT_FUNC_PRIORITY
        f = _plotly_plot_func(Val(key))
        isnothing(f) && continue
        return f(args...;kwargs...)
    end
    error("No PlotlyBase package has been loaded, make sure to load either PlotlyBase or PlutoPlotly")
end