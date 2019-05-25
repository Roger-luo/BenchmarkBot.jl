module BenchmarkBot

using PkgBenchmark, GitHub, JSON, UUIDs, Dates, Base64
export BenchmarkConfig, submit_report, submit_issue, runbenchmarks

function token()
    if haskey(ENV, "GITHUB_BENCHMARK_TOKEN")
        return authenticate(ENV["GITHUB_BENCHMARK_TOKEN"])
    else
        error("set github token by export GITHUB_BENCHMARK_TOKEN")
    end
end

const REPO = repo("QuantumBFS/YaoBenchmarks.jl")

function submit_report(repo, package, results)
    file_json = JSON.parse(
        """
        {
            "message": "automatic generated benchmark report",
            "content": "$(base64encode(sprint(export_markdown, results)))"
        }
        """
    )

    t = Dates.now()
    folder = join(["reports", year(t), month(t), day(t), package], "/")
    filepath = join([folder, "/", string(uuid1()), ".md"])
    create_file(repo, filepath, params=file_json, auth=token())
    submit_issue(repo, filepath)
end

function submit_issue(repo, filepath)
    issue_json = JSON.parse(
        """
        {
            "title": "Benchmark Report Generated for multithreading",
            "body": "benchmark report generated. See details at $(escape_string(string(file(repo, filepath).html_url)))",
            "labels": ["benchmark report"]
        }
        """
    )
    
    create_issue(repo; params=issue_json, auth=token())
end

function runbenchmarks(;package, target, baseline)
    results = judge(package, target, baseline)
    submit_report(REPO, package, results)
end

end # module
