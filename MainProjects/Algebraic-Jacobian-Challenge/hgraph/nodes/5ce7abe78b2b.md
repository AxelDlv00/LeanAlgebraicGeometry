---
author: sync
chapter: 'Section graded ring infrastructure: tensor powers and graded sections'
content_type: lemma
created: '2026-07-16T21:14:30'
generated: blueprint
label: lem:tensorProductComm_eq_refl_mathlib
lean_status: mathlib_ok
mathlib_name:
- Module.Invertible.tensorProductComm_eq_refl
order: 1303
title: Self-braiding of an invertible module is trivial (affine)
type: tex
updated: '2026-07-28T04:57:37'
---
\textit{Provided by Mathlib (\texttt{Mathlib.RingTheory.PicardGroup}).}
  Let \(R\) be a commutative ring and \(M\) an invertible \(R\)-module
  (\(\mathrm{Module.Invertible}\,R\,M\): the evaluation map
  \(M \otimes_R M^{\ast} \to R\) is bijective, equivalently \(M\) is finite
  projective of constant rank one). Then the swap involution of the tensor square
  is the identity:
  \[
    \mathrm{TensorProduct.comm}_R\,M\,M \;=\;
      \mathrm{id}_{M \otimes_R M},
  \]
  i.e.\ \(x \otimes y = y \otimes x\) in \(M \otimes_R M\) for all
  \(x, y \in M\). This is the affine kernel of self-braiding triviality. Note the
  abstract monoidal statement ``a \(\otimes\)-invertible object has
  \(\beta = \mathrm{id}\)'' is \emph{false} --- an odd line in super vector spaces
  is \(\otimes\)-invertible yet has \(\beta = -\mathrm{id}\) --- so the result
  genuinely uses the concrete swap on a module that is invertible in the
  \(\mathrm{Module.Invertible}\) sense, not mere categorical invertibility.