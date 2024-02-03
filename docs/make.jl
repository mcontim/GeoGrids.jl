using GeoGrids
using Documenter

# This is used to skip the performance_page during the docs building locally (as it takes time)
perf_page = get(ENV, "CI", "") === "true"

makedocs(
    sitename = "GeoGrids",
    format = Documenter.HTML(),
    modules = [GeoGrids],
    warnonly = true,
    repo = Documenter.Remotes.GitLab("gitlab.esa.int","tec-esc-tools","GeoGrids.jl"),
    pagesonly = true, # This only build the source files listed in pages
    pages = [
        "Home" => "index.md",
    ],
)

# This controls whether or not deployment is attempted. It is based on the value
# of the `SHOULD_DEPLOY` ENV variable, which defaults to the `CI` ENV variables or
# false if not present.
should_deploy = get(ENV,"SHOULD_DEPLOY", get(ENV, "CI", "") === "true")

if should_deploy
    using ESAGitlabTools.DocumenterHelpers

    # We create the custom deploy data
    deploy_data = get_deploy_data()

    # Documenter can also automatically deploy documentation to gh-pages.
    # See "Hosting Documentation" and deploydocs() in the Documenter manual
    # for more information.
    deploydocs(;
        deploy_data...
    )

    # We now check that the ci conf file is available in the target branch and add it otherwise 
    add_ci_configuration(deploy_data)
end
