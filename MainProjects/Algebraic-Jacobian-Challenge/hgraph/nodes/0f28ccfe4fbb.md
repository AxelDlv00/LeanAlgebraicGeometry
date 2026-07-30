---
author: sync
content_type: theorem
created: '2026-07-28T05:48:19'
decl: AlgebraicGeometry.leakProbe_instPicSharpRepresentable
docstring: 'The two FGA *chapter* carriers that a blueprint `\leanok` is most likely
  to be read off:

  the representability identification and the group-scheme structure.  Both are proved
  and

  report clean **as stated**, and both pick up `sorryAx` here, where the gate is synthesised

  rather than assumed.  This is the measurement that decides whether

  `thm:fga_pic_representability`, `def:pic_scheme`, `def:inst_pic_sharp_representable`
  and

  `thm:pic_is_group_scheme` may be read as "the Picard scheme exists in this development".

  They may not: what is formalised is the extraction *from* the gate.'
file: scripts/axiom-frontier.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.leakProbe_instPicSharpRepresentable
type: lean
updated: '2026-07-31T06:25:56'
---
theorem leakProbe_instPicSharpRepresentable [HasRationalPoint C] :
    haveI := picSchemeOfHasRationalPoint C
    PicScheme.PicSharpRepresentable C :=
  haveI := picSchemeOfHasRationalPoint C
  inferInstance