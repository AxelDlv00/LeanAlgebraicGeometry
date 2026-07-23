---
author: sync
chapter: '{\v C}ech computation of higher direct images $R^i f_*$ (unconditional)'
content_type: lemma
created: '2026-07-16T21:14:29'
generated: blueprint
label: lem:section_cech_complex_mapop_iso
lean_status: lean_ok
order: 208
title: Opposite-transport identification of the section {\v C}ech complex
type: tex
updated: '2026-07-24T03:02:14'
---
With the notation above, composing the opposite-transport iso
  \(\operatorname{homCechComplexMapOpIso}\) of
  Lemma~\ref{lem:cech_complex_op_identification} with the {\v C}ech hom-identification
  \(\operatorname{cechComplex\_hom\_identification}\) of
  Lemma~\ref{lem:cech_complex_hom_identification} gives an isomorphism of cochain
  complexes
  \[
    \bigl((\operatorname{preadditiveYoneda}.\mathrm{obj}\,\mathcal{F}).
      \operatorname{mapHomologicalComplex}\bigr).\mathrm{obj}
      \bigl(\operatorname{HomologicalComplex.op}
        (\operatorname{cechFreePresheafComplex} \mathcal{U})\bigr)
    \;\cong\;
    \operatorname{sectionCechComplex}(\operatorname{coverOpen} \mathcal{U})\,
      \mathcal{F},
  \]
  i.e.\ \(\operatorname{sectionCechComplexMapOpIso}\) is
  \(\operatorname{homCechComplexMapOpIso}^{-1}\) followed by
  \(\operatorname{cechComplex\_hom\_identification}\). This is the bridge that lets the
  mapped-opposite of the free resolution be transported onto the section {\v C}ech
  complex of Definition~\ref{def:section_cech_complex}.

  The companion \(\operatorname{sectionCechComplexMapOpIsoFam}\) is the cover-agnostic
  raw-finite-family mirror of this transport, stated over an arbitrary finite family
  \((U_i)_{i \in \iota}\) of opens with \emph{no} covering hypothesis.