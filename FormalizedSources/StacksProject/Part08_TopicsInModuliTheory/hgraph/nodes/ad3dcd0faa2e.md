---
author: sync
chapter: Moduli Stacks
content_type: lemma
created: '2026-08-27T16:31:52'
generated: blueprint
group: moduli
label: moduli-lemma-quot-tensor-invertible
lean_status: empty
order: 19
ref: stacks:0DP7
title: Quot tensor invertible
type: tex
updated: '2026-08-27T16:31:52'
---
\href{https://stacks.math.columbia.edu/tag/0DP7}{\texttt{Stacks tag 0DP7}}


Let $f : X \to B$ and $\mathcal{F}$ be as in the introduction to this section.
Let $\mathcal{L}$ be an invertible $\mathcal{O}_X$-module.
Then tensoring with $\mathcal{L}$ defines an isomorphism
$$
\Quotfunctor_{\mathcal{F}/X/B}
\longrightarrow
\Quotfunctor_{\mathcal{F} \otimes_{\mathcal{O}_X} \mathcal{L}/X/B}
$$
Given a numerical polynomial $P(t)$, then setting $P'(t) = P(t + 1)$
this map induces an isomorphism
$\Quotfunctor^P_{\mathcal{F}/X/B}
\longrightarrow
\Quotfunctor^{P'}_{\mathcal{F} \otimes_{\mathcal{O}_X} \mathcal{L}/X/B}$
of open and closed substacks.