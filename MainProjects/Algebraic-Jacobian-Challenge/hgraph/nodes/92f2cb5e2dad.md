---
author: sync
chapter: '{\v C}ech computation of higher direct images $R^i f_*$ (unconditional)'
content_type: lemma
created: '2026-07-16T21:14:29'
generated: blueprint
label: lem:pushPull_coprod_prod
lean_status: lean_ok
order: 366
title: Push--pull on a finite coproduct of legs is the product of the leg push--pulls
type: tex
updated: '2026-07-24T17:02:58'
---
Let \((\mathrm{legs} : \iota \to \operatorname{Over} X)\) be a finite family of objects of
  the slice category over a scheme \(X\) (\(\iota\) finite), and form the coproduct
  \(\coprod_{i \in \iota} \mathrm{legs}\,i\) with structure map
  \(\operatorname{Sigma.desc}(i \mapsto (\mathrm{legs}\,i).\mathrm{hom}) : \coprod_i
  \mathrm{legs}\,i \to X\). Then the push--pull object on this coproduct is the product of
  the per-leg push--pull objects:
  \[
    \operatorname{pushPullObj}\mathcal{F}\,\Bigl(\operatorname{Over.mk}\bigl(
      \operatorname{Sigma.desc}(i \mapsto (\mathrm{legs}\,i).\mathrm{hom})\bigr)\Bigr)
      \;\cong\;
    \prod_{i \in \iota} \operatorname{pushPullObj}\mathcal{F}\,(\mathrm{legs}\,i)
    \qquad \text{in } X.\mathrm{Modules}.
  \]
  This is the general indexed-coproduct\(\to\)product disjoint-union decomposition of a
  module sheaf: the legs may have overlapping images in \(X\), but they are disjoint inside
  the coproduct space \(\coprod_i \mathrm{legs}\,i\), so push--pull splits componentwise.