---
author: sync
chapter: '{\v C}ech computation of higher direct images $R^i f_*$ (unconditional)'
content_type: lemma
created: '2026-07-16T21:14:29'
generated: blueprint
label: lem:restrictStalkNatIso_mathlib
lean_status: mathlib_ok
mathlib_name:
- AlgebraicGeometry.Scheme.Modules.restrictStalkNatIso
order: 349
title: Restrict--stalk comparison along an open immersion
type: tex
updated: '2026-07-24T11:03:43'
---
\textit{Provided by Mathlib
  (\texttt{Mathlib.AlgebraicGeometry.Modules.Sheaf}).}
  Let \(f : U \hookrightarrow X\) be an open immersion of schemes and \(y \in U\) a point with
  image \(x = f(y)\). For a module sheaf \(\mathcal{M} \in X.\mathrm{Modules}\), restricting
  \(\mathcal{M}\) along \(f\) and then taking the stalk of the underlying presheaf of abelian
  groups at \(y\) is naturally isomorphic to the stalk of \(\mathcal{M}\) (as a presheaf of
  abelian groups) at \(x\); i.e.\ there is a natural isomorphism between the functors
  \(\mathcal{M} \mapsto (\operatorname{restrict} f\,\mathcal{M})_y\) and \(\mathcal{M} \mapsto
  \mathcal{M}_x\).