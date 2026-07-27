---
author: sync
chapter: Relative Picard sheaf --- \texttt{Scheme.Modules.tensorObj} substrate (A.1.c.SubT)
content_type: lemma
created: '2026-07-16T21:14:29'
generated: blueprint
label: lem:tensorobj_restrict_iso
lean_status: lean_ok
order: 631
title: Tensor product commutes with restriction along an open immersion
type: tex
updated: '2026-07-27T15:50:36'
---
Let \(X\) be a scheme, let \(M, N \in \Scheme.\mathtt{Modules}\,X\) be
  \emph{arbitrary} \(\mathcal{O}_X\)-modules, and let
  \(f : U \hookrightarrow X\) be an open immersion, with \((-)|_f\) the
  restriction of \(\mathcal{O}_X\)-modules along \(f\). The canonical comparison
  morphism
  \[
    (M \otimes_X N)\big|_f
      \;\xrightarrow{\;\;}\;
    M\big|_f \;\otimes_U\; N\big|_f
  \]
  is an isomorphism. No local-freeness, flatness, or line-bundle hypothesis on
  \(M, N\) is required: the statement holds for all \(\mathcal{O}_X\)-modules.
  The reason is structural to open immersions --- restriction along \(f\) is
  base change along the structure-sheaf \emph{isomorphism} induced by \(f\),
  not along a general ring map --- and base change along a ring isomorphism is
  trivially invertible and commutes with tensor products.