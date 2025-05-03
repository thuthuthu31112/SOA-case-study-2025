make_hist = function (df) {
  df %>% 
    ggplot(aes(x = loss_given_failure_prop_qm + 
                 loss_given_failure_liab_qm + 
                 loss_given_failure_bi_qm)) +
    geom_histogram(binwidth = 10, fill = "lightsteelblue") +
    labs(
      title = deparse(substitute(df)),
      x = "Total Loss Given Failure (in QM units)",
      y = "Count"
    ) +
    theme_minimal() +
    theme(
      text = element_text(family = "serif")
    )
}

make_hist(lumevale)
make_hist(lyndrassia)
make_hist(navaldia)

design <- "
                  ABC
                "

layout_plot <- make_hist(lumevale) +
  make_hist(lyndrassia) +
  make_hist(navaldia) +
  plot_layout(design = design)
