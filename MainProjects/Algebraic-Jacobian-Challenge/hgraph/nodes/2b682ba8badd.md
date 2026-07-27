---
author: sync
content_type: instance
created: '2026-07-27T19:45:31'
decl: AlgebraicGeometry.Adelic.instIsIntegralP1OverLeft
docstring: '**`ℙ¹_k` is an integral scheme.**  Both standard charts have polynomial

  section rings (`Picard/RigidPushforwardP1ChartSections.lean`), hence are

  integral domains, and the charts genuinely overlap (`p1Chart_inf_ne_bot`); so

  `ℙ¹_k` is reduced and irreducible (`Picard/RigidPushforwardP1Topology.lean`).


  This is the `H⁰`-finiteness anchor of the B3 ℙ¹ engine, in the sharpest form

  isolated in §5 of `Picard/RigidPushforwardP1Constants.lean`: it feeds

  `finite_appTop_of_universallyClosed`, hence `Module.Finite k Γ(ℙ¹_k, 𝒪)`,

  hence — by qcqs `H⁰` flat base change and Serre dévissage — the engine''s

  `hH0` at every finitely generated `k`-algebra.'
file: AlgebraicJacobian/Picard/RigidPushforwardInstance.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.instIsIntegralP1OverLeft
type: lean
updated: '2026-07-27T19:45:31'
---
instance instIsIntegralP1OverLeft : IsIntegral ((p1Over k).left) :=
  isIntegral_p1Over_left_of_isDomain_charts k inferInstance inferInstance
    (p1Chart_inf_ne_bot k)

/-! ## §2. The ℙ¹ engine statement, and the gate's `locallyFree` field -/