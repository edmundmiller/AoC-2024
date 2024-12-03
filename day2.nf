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
    ch_safe_reports = ch_input.filter { levels ->
        // Check if the levels are strictly increasing or strictly decreasing
        def increasing = levels.every { idx ->
            idx == levels[0] || idx > levels[levels.indexOf(idx) - 1]
        }
        def decreasing = levels.every { idx ->
            idx == levels[0] || idx < levels[levels.indexOf(idx) - 1]
        }

        // Must be either all increasing or all decreasing
        if (!increasing && !decreasing) {
            return false
        }

        // Check if adjacent levels differ by at least 1 and at most 3
        return levels.every { idx ->
            if (idx == levels[0]) {
                return true
            }
            def diff = (idx.toInteger() - levels[levels.indexOf(idx) - 1].toInteger()).abs()
            return diff >= 1 && diff <= 3
        }
    }

    emit:
    safe_reports = ch_safe_reports
}
