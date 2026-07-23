---
author: sync
chapter: Relative Picard sheaf --- \texttt{Scheme.Modules.tensorObj} substrate (A.1.c.SubT)
content_type: lemma
created: '2026-07-16T21:14:29'
generated: blueprint
label: lem:pullback_tensor_map_eq_sheafify_delta
lean_status: lean_ok
order: 802
title: '$\delta$ mate-identification: the tensor comparison is the sheafified cotensorator
  (Cone A)'
type: tex
updated: '2026-07-24T03:02:14'
---
Let \(f : Y \to X\) and \(M, N \in \Scheme.\mathtt{Modules}\,X\). The sheaf-level tensor comparison
  \(\mathtt{pullbackTensorMap}\,f\,M\,N\) (\cref{lem:pullback_tensor_map}) is the sheafification
  transport of the presheaf oplax cotensorator
  \(\delta\,(\mathtt{pullback}\,\varphi')\,M_{\mathrm{val}}\,N_{\mathrm{val}}\)
  (\cref{lem:presheaf_pullback_oplaxmonoidal}):
  \[
    \mathtt{pullbackTensorMap}\,f\,M\,N
      = (\mathtt{pullbackValIso}\,f\,(M \otimes_X N)).\mathrm{inv}
        \mathbin{;} a_Y.\mathrm{map}\bigl(\delta\,(\mathtt{pullback}\,\varphi')\,M_{\mathrm{val}}\,N_{\mathrm{val}}\bigr)
        \mathbin{;} \beta_{M,N},
  \]
  where \(\beta_{M,N}\) is the tensor-of-\(\mathtt{pullbackValIso}\) reconciliation
  (\cref{def:pullback_val_iso}, \cref{def:scheme_modules_tensorobj}) on the \(\delta\)-codomain,
  identifying the \(a_Y\)-image of the presheaf tensor with \(f^{*}M \otimes_Y f^{*}N\).