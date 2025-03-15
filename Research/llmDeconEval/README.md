# Comparison of the Old and New Decontamination Algorithms:

#### The old algorithm was tested on the ARC-Easy task, while the new algorithm was run for both the Easy and Challenge versions. Below are the results, also averaged.

<hr>

| Alg-Version     | Task          |   Recall (TPR) |   Specificity (TNR) |   Precision (PPV) |   Negative Predictive Value (NPV) |   Accuracy |   F1 Score |
|-------------|---------------|----------------|---------------------|-------------------|-----------------------------------|------------|------------|
| 1.0         | ARC-Easy      |        95.5367 |             51.2035 |           80.1248 |                           84.7826 |    81.0443 |    87.1546 |
| 2.0         | ARC-Challenge |        97.0476 |             76.8317 |           89.7007 |                           92.6014 |    90.4823 |    93.2296 |
| 2.0         | ARC-Easy      |        96.2898 |             71.1019 |           94.006  |                           80.2817 |    91.8761 |    95.1342 |
| Avg-New     |       |        96.6687 |             73.9668 |           91.8534 |                           86.4416 |    91.1792 |    94.1819 |
| Improvement |       |         1.13   |             22.76   |           11.73   |                            1.66   |    10.13   |     7.03   |


### The results were evaluated using LLM GPT-4o (LLM as a Judge), with a human in the loop when the LLM encountered uncertainties.


#### Interesting Statistics (for final verification, development, and testing)
- Total cost: **$13.0** (50 PLN)
- Number of requests: **8304**