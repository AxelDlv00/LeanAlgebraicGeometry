---
author: sync
chapter: Relative Picard sheaf --- \texttt{Scheme.Modules.tensorObj} substrate (A.1.c.SubT)
content_type: theorem
created: '2026-07-16T21:14:29'
generated: blueprint
label: thm:rel_pic_addcommgroup_via_tensorobj
lean_status: lean_ok
order: 683
title: Abelian-group instance on the relative Picard quotient via \(\Scheme.\mathtt{Modules}.\mathtt{tensorObj}\)
type: tex
updated: '2026-07-24T11:03:43'
---
\textit{Source: [Kleiman], ``The Picard scheme'', \S 2,
  Defs.~df:aPf + df:Pfs (the target category is the category of abelian
  groups; the relative Picard functor is a quotient of abelian groups).}
  Let \(C/k\) be a smooth proper geometrically integral curve over a
  field \(k\), let \(\pi_C : C \to \Spec k\) be the structure morphism,
  and let \(T\) be a \(k\)-scheme with structure morphism
  \(\pi_T : T \to \Spec k\). The set
  \[
    \Pic^{\sharp}_{C/k}(T) \;\;:=\;\; \Pic(C \times_k T) \,/\, \pi_T^*\Pic(T)
  \]
  of \cref{thm:relative_pic_quotient_well_defined} carries a canonical
  abelian-group structure with addition
  \(\bigl[\,\mathcal{L}\,\bigr] + \bigl[\,\mathcal{L}'\,\bigr]
   := \bigl[\,\mathcal{L} \otimes_{C \times_k T} \mathcal{L}'\,\bigr]\),
  neutral element \(\bigl[\,\mathcal{O}_{C \times_k T}\,\bigr]\), and
  inverse
  \(-\bigl[\,\mathcal{L}\,\bigr] := \bigl[\,\mathcal{L}^{-1}\,\bigr]\),
  where \(\otimes_{C \times_k T}\) and \((-)^{-1}\) are the operations
  supplied by the substrate of \cref{def:scheme_modules_tensorobj}
  restricted to the \(\texttt{LineBundle.OnProduct}\,\pi_C\,\pi_T\) carrier
  via \cref{lem:tensorobj_lift_onproduct}. With this structure the quotient
  map
  \(\Pic(C \times_k T) \twoheadrightarrow \Pic^{\sharp}_{C/k}(T)\) is a
  surjective group homomorphism with kernel exactly \(\pi_T^*\Pic(T)\),
  in agreement with \cref{lem:rel_pic_sharp_groupoid}.