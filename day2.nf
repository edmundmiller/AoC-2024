params.input = "${projectDir}/assets/day2.txt"

workflow {
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
        // Convert levels to integers
        def intLevels = levels*.toInteger()

        // Check if the levels are strictly increasing or strictly decreasing
        def increasing = intLevels.withIndex().every { val, idx ->
            idx == 0 || val > intLevels[idx - 1]
        }
        def decreasing = intLevels.withIndex().every { val, idx ->
            idx == 0 || val < intLevels[idx - 1]
        }
        // Check for no equal adjacent values
        def noEquals = intLevels.withIndex().every { val, idx ->
            idx == 0 || val != intLevels[idx - 1]
        }

        // Must be either all increasing or all decreasing, and no equal values
        if (!noEquals) {
            // Fail if there are equal adjacent values
            return false
        }
        if (!increasing && !decreasing) {
            // Fail if neither increasing nor decreasing
            return false
        }

        // Check if adjacent levels differ by at least 1 and at most 3
        def validDifferences = intLevels.withIndex().every { val, idx ->
            if (idx == 0) {
                return true
            }
            def diff = (val - intLevels[idx - 1]).abs()
            return diff >= 1 && diff <= 3
        }

        return validDifferences
    }

    emit:
    safe_reports = ch_safe_reports
}
