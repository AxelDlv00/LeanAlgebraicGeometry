---
author: sync
chapter: '{\v C}ech computation of higher direct images $R^i f_*$ (unconditional)'
content_type: lemma
created: '2026-07-16T21:14:29'
generated: blueprint
label: lem:isLocalizedModule_of_exact
lean_status: lean_ok
order: 281
title: 'Kernel comparison: a left-exact ladder localises on the left'
type: tex
updated: '2026-07-27T15:50:36'
---
Let \(S \subseteq R\) be a submonoid of a commutative ring, and consider a commutative ladder of
  \(R\)-modules
  \[
    \begin{array}{ccccc}
      A & \xrightarrow{\ i\ } & B & \xrightarrow{\ p\ } & C \\
      \big\downarrow{\,a} & & \big\downarrow{\,b} & & \big\downarrow{\,c} \\
      A' & \xrightarrow{\ i'\ } & B' & \xrightarrow{\ p'\ } & C'
    \end{array}
  \]
  in which both rows are left-exact (\(i\) and \(i'\) injective, with \(\operatorname{im} i = \ker p\) and
  \(\operatorname{im} i' = \ker p'\)). Suppose the two right-hand verticals \(b : B \to B'\) and
  \(c : C \to C'\) are localisation maps at \(S\) (\(\operatorname{IsLocalizedModule} S\, b\) and
  \(\operatorname{IsLocalizedModule} S\, c\)). Then the left vertical \(a : A \to A'\) is a localisation map
  at \(S\) (\(\operatorname{IsLocalizedModule} S\, a\)). This is the converse direction of the Mathlib fact
  that localisation preserves exactness (Lemma~\ref{lem:localized_module_map_exact_mathlib}): there, the
  verticals being localisations forces the rows to stay exact; here, the rows being exact lets a
  localisation on the two right columns be transported to the left column.