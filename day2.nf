params.input = "${projectDir}/assets/day2_example.txt"

workflow {
    // Why give me a file split by 3 spaces?
    ch_input = channel
        .fromPath(params.input)
        .splitCsv(
            sep: " ",
            strip: true
        )

    PART1(ch_input).view { "Part 1: ${it}" }
}

workflow PART1 {
    take:
    ch_input

    main:
    ch_safe_reports = ch_input.count { levels ->
    // Check if the levels are strictly increasing or strictly decreasing
    boolean increasing = levels.everyWithIndex { it, idx ->
        idx == 0 || it > levels[idx - 1]
    }
    boolean decreasing = levels.everyWithIndex { it, idx ->
        idx == 0 || it < levels[idx - 1]
    }

    if (!increasing && !decreasing) {
        return false
    }

    // Check if adjacent levels differ by at least 1 and at most 3
    levels.everyWithIndex { it, idx ->
        idx == 0 || (Math.abs(it - levels[idx - 1]) in 1..3)
    }
}

    emit:
    safe_reports = ch_safe_reports
}
