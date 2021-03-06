# Read in the results from the model fit & backtest steps, and make a plot that
# compares them.

library(argparser, quietly=TRUE)
library(jsonlite, quietly=TRUE)

analyze <- function(files) {
    # Make the ROC plot for each input file
    for (i in 1:length(files)) {
        data <- read.csv(files[i])

        # Compute True Positive Rate and False Positive Rate
        trues <- subset(data, true == 1)
        falses <- subset(data, true == 0)
        roc <- data.frame(t(sapply(seq(0, 1, 0.01),
            function(th) {
                # For this threshold: TPR is the odds that the prediction exceeds
                # the threshold for real trues (correctly marked true), and FPR is
                # the odds that it exceeds the threshold for real falses
                # (incorrectly marked true).
                newpredT <- trues$proba > th
                newpredF <- falses$proba > th
                c(tpr=sum(newpredT)/nrow(trues), fpr=sum(newpredF)/nrow(falses))
            }
        )))

        if (i == 1) {
            plot(roc$fpr, roc$tpr, col=i, xlim=c(0,1), ylim=c(0,1), type="l",
                 main="ROC curve for models", xlab="False Positive Rate", ylab="True Positive Rate")
        } else {
            lines(roc$fpr, roc$tpr, col=i)
        }
    }

    # Show the baseline of a random classifier, and print the legend.
    lines(c(0,1), c(0,1), col=8, lty=2, lwd=2)
    legend("bottomright", legend=c(gsub(".*/", "", files), "RANDOM"), col=c(1:length(files), 8),
           lty=c(rep(1, length(files)), 2), lwd=c(rep(1, length(files)), 2))
}


main <- function()
{
    pp <- arg_parser("Summarize backtest results")
    pp <- add_argument(pp, "dir", help="path to results")

    argv <- parse_args(pp)

    files <- list.files(argv$dir, full.names=TRUE)

    # Save the plot to a temporary location
    if (!dir.exists("/conducto/data/pipeline/tmp/images")) {
        dir.create("/conducto/data/pipeline/tmp/images", recursive=TRUE)
    }
    png("/conducto/data/pipeline/tmp/images/r_analyze.png", width=475, height=475)
    analyze(files)
    dev.off()

    # Get the URL to this image
    url <- fromJSON(system("conducto-data-pipeline url tmp/images/r_analyze.png", intern=TRUE))

    # Display the image using markdown
    cat(sprintf("<ConductoMarkdown>\n![Best model](%s)\n</ConductoMarkdown>\n\n", url))
}


main()