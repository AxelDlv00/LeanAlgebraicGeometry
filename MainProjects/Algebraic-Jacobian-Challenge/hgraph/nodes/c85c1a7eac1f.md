---
author: sync
chapter: '{\v C}ech computation of higher direct images $R^i f_*$ (unconditional)'
content_type: lemma
created: '2026-07-16T21:14:29'
generated: blueprint
label: lem:openimm_bareBC_isIso
lean_status: lean_ok
order: 522
title: 'Stage 2, assembly: \(\operatorname{bareBC}\) is an isomorphism'
type: tex
updated: '2026-07-26T00:08:21'
---
For the cartesian square \(p' \cdot g' = g'_V \cdot p\) of \cref{lem:openimm_beckchevalley} with
  \(p\) an open immersion, \(V\) affine (\([\mathrm{IsAffine}\,V]\)), \(X\) separated, and
  \(\mathcal{F}\) a \emph{quasi-coherent} \(\mathcal{O}_X\)-module
  (\(\mathtt{hF} : \mathcal{F}.\mathrm{IsQuasicoherent}\)), the bare base-change map
  \(\operatorname{bareBC}\) (\cref{lem:openimm_bareBC}), evaluated at \(G = p^*\mathcal{F}\), is an
  isomorphism. (These hypotheses are essential: the proof applies the affine member node
  \cref{lem:openimm_bareBC_app_isIso_affine}, which needs each \(V \cap U_j\) affine ---
  hence \(V\) affine and \(X\) separated --- and needs \(p^*\mathcal{F}\) quasi-coherent ---
  hence \(\mathtt{hF}\). The arbitrary-\(\mathcal{F}\) form is false.)