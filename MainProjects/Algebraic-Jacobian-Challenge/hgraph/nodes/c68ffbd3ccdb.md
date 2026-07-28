---
author: sync
chapter: '{\v C}ech computation of higher direct images $R^i f_*$ (unconditional)'
content_type: definition
created: '2026-07-16T21:14:29'
generated: blueprint
label: def:cech_complex_base_change_cosimplicialIso
lean_status: lean_ok
order: 543
title: The {\v C}ech base-change cosimplicial isomorphism \(e\)
type: tex
updated: '2026-07-28T22:30:26'
---
The cosimplicial natural isomorphism \(e\) required by
  \cref{def:cech_complex_base_change_iso_of_cosimplicialIso} is assembled from the two
  base-change leaves. It is the composite
  \[
    e \;=\;
      \bigl(\cref{lem:cech_pushforward_baseChange_natIso}\bigr)
      \mathbin{;}
      (\operatorname{pushforward} f')\!.\operatorname{mapIso}
        \bigl(\cref{lem:twisted_cech_nerve_iso}\bigr),
  \]
  i.e.\ first the Beck--Chevalley natural iso
  \(g^* \circ (\operatorname{pushforward} f) \cong (\operatorname{pushforward} f')
  \circ (g')^*\) whiskered through the {\v C}ech nerve, followed by the image under the
  functor \(\operatorname{pushforward} f'\) (via \(\operatorname{Functor.mapIso}\)) of the
  twisted-nerve identification
  \((g')^* \circ \operatorname{CechNerve}(\mathfrak{U}, -) \cong
  \operatorname{CechNerve}(\mathfrak{U}', (g')^*(-))\). Both factors are isomorphisms of
  cosimplicial objects, so \(e\) is one as well; it is precisely the hypothesis consumed
  by \cref{def:cech_complex_base_change_iso_of_cosimplicialIso}.