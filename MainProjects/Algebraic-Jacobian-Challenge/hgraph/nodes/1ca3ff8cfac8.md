---
author: sync
chapter: The relative Picard functor and its \'etale sheafification
content_type: definition
created: '2026-07-16T21:14:29'
generated: blueprint
label: def:rel_pic_etale_sheafification
lean_status: lean_ok
order: 619
title: \'Etale sheafification of the relative Picard presheaf
type: tex
updated: '2026-07-24T11:03:43'
---
\textit{Source: [Kleiman], ``The Picard scheme'', \S 2,
  Def.~df:Pfs (the \'etale-sheaf notation \(\Pic_{(X/S)\et}\)) and the
  associated-sheaf paragraph immediately following df:Pfs.}
  Let \(C/k\) be a smooth proper geometrically integral curve. The
  \emph{\'etale-sheafified relative Picard functor} is the sheafification of
  the presheaf \(\Pic^\sharp_{C/k}\) (\cref{thm:rel_pic_sharp_presheaf}) in the
  global \'etale topology on \((\Sch/k)\):
  \[
    \Pic^\sharp_{(C/k)\et} \;\;:=\;\;
       \bigl(\Pic^\sharp_{C/k}\bigr)^{\sim_{\et}}.
  \]
  Equivalently, \(\Pic^\sharp_{(C/k)\et}\) is the unique (up to canonical
  isomorphism) sheaf of abelian groups on the \'etale site of \(\Sch/k\)
  equipped with a presheaf morphism $\Pic^\sharp_{C/k} \to
  \Pic^\sharp_{(C/k)\et}$ which is universal among presheaf morphisms from
  \(\Pic^\sharp_{C/k}\) to \'etale sheaves of abelian groups. In Kleiman's
  notation this is \(\Pic_{(X/S)\et}\) with \(X = C\) and \(S = \Spec k\). When \(k\)
  is algebraically closed and \(T = \Spec k'\) for an algebraically closed field
  extension \(k'/k\), the natural map
  \(\Pic^\sharp_{C/k}(T) \to \Pic^\sharp_{(C/k)\et}(T)\) is a bijection (Kleiman
  Exercise ex:Alr, L1357--L1361).