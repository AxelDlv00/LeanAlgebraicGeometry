---
author: sync
chapter: Relative Picard sheaf --- \texttt{Scheme.Modules.tensorObj} substrate (A.1.c.SubT)
content_type: lemma
created: '2026-07-16T21:14:29'
generated: blueprint
label: lem:sheafify_pullbackcomp_hom_inv_cancel
lean_status: lean_ok
order: 661
title: Sheafification kills the \(\mathtt{pullbackComp}\) hom--inv pair (D3$'$ residual
  brick)
type: tex
updated: '2026-07-25T20:41:01'
---
Let \(h : Z \to Y\) and \(f : Y \to X\) be composable, write
  \(\mathtt{PrPbComp} = \mathtt{PresheafOfModules.pullbackComp}\,\varphi'_f\,\varphi'_h\) for the
  presheaf pullback pseudofunctoriality isomorphism
  \(\mathtt{pullback}\,\varphi'_f \circ \mathtt{pullback}\,\varphi'_h \cong
  \mathtt{pullback}\,\varphi'_{h\circ f}\), and let \(a_Z\) be sheafification of presheaves of
  modules on \(Z\). Then for every presheaf \(T\) over \(X\) the sheafified hom--inv pair cancels:
  \[
    a_Z.\mathrm{map}\bigl(\mathtt{PrPbComp}.\mathrm{hom}.\mathrm{app}\,T\bigr) \;\mathbin{;}\;
    a_Z.\mathrm{map}\bigl(\mathtt{PrPbComp}.\mathrm{inv}.\mathrm{app}\,T\bigr) \;=\;
    \mathrm{id}_{a_Z.\mathrm{map}\,(\cdots)}.
  \]