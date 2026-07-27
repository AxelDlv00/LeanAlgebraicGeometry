---
author: sync
content_type: theorem
created: '2026-07-27T17:00:52'
decl: AlgebraicGeometry.Adelic.p1PushforwardLocalFreenessBridge_of_rank
docstring: "**Leaf 3 (`P1PushforwardLocalFreenessBridge`) modulo the rank\nidentification.**\
  \  Granting that the pointwise rank of the `Γ(Spec A, ⊤)`-module\n`Γ(Spec A, p_*\
  \ M)` at `t` is the fibre invariant `p.fiberH0 M t`, the output\nbridge of `Picard/RigidPushforwardGate.lean`\
  \ §2 follows from the sheaf-theoretic\npackage of this file:\n\n* `Γ(Spec A, p_*\
  \ M) ≅ ker d` (`pushforwardTop_linearEquiv_ker`), so the engine's\n  finiteness\
  \ and projectivity of `ker d` are finiteness and projectivity of the\n  pushforward\
  \ sections (`module_finite_pushforwardTop`,\n  `module_projective_pushforwardTop`),\
  \ read over `A` rather than\n  `Γ(Spec A, ⊤)` via `module_finite_top_of_gammaSpecTop`\
  \ and its projective\n  companion;\n* `p_* M` is quasi-coherent (`Scheme.Modules.pushforward_isQuasicoherent`,\n\
  \  Stacks 01XJ, `p` being quasi-compact and quasi-separated as a base change of\n\
  \  the proper `ℙ¹_k ⟶ Spec k`);\n* hence `p_* M` is free of rank `sectionsRankAtStalk\
  \ (p_* M) t` on a\n  neighbourhood of `t` (`exists_free_restrict_of_finite_projective_sections'`,\n\
  \  Stacks 00NX).\n\nThe hypothesis `P1RankIdentity` is *not* proved here: it is\
  \ the fibre-chart\nbase-change comparison `κ(t) ⊗_{Γ(Spec A,⊤)} H⁰ ≅ H⁰(ℙ¹_t, M_t)`\
  \ (Stacks 02KG\nin degree 0), the `B = κ(t)` case of the engine's fourth conclusion,\
  \ and is the\nremaining half of leaf 3.\n\nSources: Stacks 00NX, 01XJ, 02KG; Mumford,\
  \ *Abelian Varieties*, II §5;\nEGA III 7.9.9."
file: AlgebraicJacobian/Picard/RigidPushforwardP1Sheaf.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.p1PushforwardLocalFreenessBridge_of_rank
type: lean
updated: '2026-07-27T17:00:52'
---
theorem p1PushforwardLocalFreenessBridge_of_rank
    (A : Type u) [CommRing A] [Algebra k A] [Algebra.FiniteType k A]
    (hrank : P1RankIdentity k A) :
    P1PushforwardLocalFreenessBridge k A := by
  intro M hfp hsurj hfin hproj hbc t
  haveI := hfp
  haveI : ((Scheme.Modules.pushforward (pullback.snd (p1Over k).hom
      (Spec.map (CommRingCat.ofHom (algebraMap k A))))).obj M).IsQuasicoherent :=
    Scheme.Modules.pushforward_isQuasicoherent _ M
  have hfin' := module_finite_top_of_gammaSpecTop
    ((Scheme.Modules.pushforward (pullback.snd (p1Over k).hom
      (Spec.map (CommRingCat.ofHom (algebraMap k A))))).obj M)
    (module_finite_pushforwardTop A M hfin)
  have hproj' := module_projective_top_of_gammaSpecTop
    ((Scheme.Modules.pushforward (pullback.snd (p1Over k).hom
      (Spec.map (CommRingCat.ofHom (algebraMap k A))))).obj M)
    (module_projective_pushforwardTop A M hproj)
  obtain ⟨U, htU, hiso⟩ := exists_free_restrict_of_finite_projective_sections'
    ((Scheme.Modules.pushforward (pullback.snd (p1Over k).hom
      (Spec.map (CommRingCat.ofHom (algebraMap k A))))).obj M) hfin' hproj' t
  exact ⟨U, htU, (hrank M hfp hsurj hfin hproj hbc t) ▸ hiso⟩