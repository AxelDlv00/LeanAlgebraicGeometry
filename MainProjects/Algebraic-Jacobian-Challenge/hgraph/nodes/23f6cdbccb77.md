---
author: sync
chapter: '{\v C}ech computation of higher direct images $R^i f_*$ (unconditional)'
content_type: lemma
created: '2026-07-16T21:14:29'
generated: blueprint
label: lem:pushforward_slice_pullback_iso
lean_status: lean_ok
order: 455
title: Pullback along $\psi_r$ realizes the per-slice pushforward
type: tex
updated: '2026-07-24T03:02:14'
---
Let \(\varphi : X \cong Y\), \(U_i \subseteq X\), \(V_i = \varphi.\mathrm{inv}^{-1}\,U_i\), let
  \(\psi_r\) be the slice structure-sheaf ring map of Lemma~\ref{lem:slice_structureSheaf_hom}, and write
  \(\Phi = \operatorname{pushforwardEquivOfIso}\varphi\). For every \(\mathcal{O}_X\)-module \(H\) the
  pullback functor \(\operatorname{pullback}\psi_r : \operatorname{SheafOfModules}\mathcal{O}_{U_i} \to
  \operatorname{SheafOfModules}\mathcal{O}_{V_i}\) applied directly to the slice
  \(H.\operatorname{over} U_i\) (which already lies in its domain) is isomorphic to the restricted
  pushforward:
  \[
    \bigl(\operatorname{pullback}\psi_r\bigr).\mathrm{obj}\bigl(H.\operatorname{over} U_i\bigr)
      \;\cong\;
    \bigl(\Phi.\mathrm{functor}.\mathrm{obj}\, H\bigr).\operatorname{over} V_i .
  \]