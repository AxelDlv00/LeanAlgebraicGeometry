---
author: sync
content_type: structure
created: '2026-07-24T17:02:47'
decl: AlgebraicGeometry.NormalizedCechComparison
docstring: "**The σ-normalized comparison datum ((C2) effectivity, brick E1 — the\
  \ Stage-0\nrecord).**  Fix a curve point `σ : overSpec k A ⟶ C` and a unit Čech\
  \ cocycle `γ` on a\npointed cover `\U0001D4A9` of the curve `X_B = (C ⊗ Spec B).left`,\
  \ representing the rigidified\nclass `L = CechPic.mk \U0001D4A9 γ.class` of the\
  \ (C2) setting.  Writing `s_B, s_q` for the\nsections of the projections attached\
  \ to the base changes of `σ` to `B` and `B ⊗[A] B`,\nand `u₁, u₂ : X_{B⊗B} ⟶ X_B`,\
  \ `q₁, q₂ : Spec (B ⊗[A] B) ⟶ Spec B` for the coprojection\nmaps, this packages:\n\
  \n* (`sectionTriv`, `sectionTriv_rel`) a trivializing `0`-cochain `ρ` of the\n \
  \ section-pullback `s_B^♯ γ`, on the pullback cover `\U0001D4A9.pullback s_B` of\
  \ `Spec B` itself:\n  `ρ b ⋅ (s_B^♯ γ)(b,b') = ρ b'` on pairwise overlaps — the\
  \ cochain shadow of the\n  rigidification hypothesis `σ_B^* L = 1` (no refinement\
  \ is needed:\n  `Scheme.CechPic.mk_eq_one_iff`);\n* (`cover`, `le_pullbackInl`,\
  \ `le_pullbackInr`) a pointed cover `\U0001D4B2` of the curve\n  `X_{B⊗B}` over\
  \ the double base, refining both coprojection pullbacks of `\U0001D4A9` — a plain\n\
  \  `PointedCover` common refinement (`Scheme.CechPic.mk_eq_mk_iff`), *not* a\n \
  \ `BasicRefinement`: the basic-refinement calculus requires an affine carrier and\n\
  \  `X_{B⊗B}` is a curve product; basic refinements re-enter only inside the affine\
  \ pieces\n  of the per-piece descent (brick E2);\n* (`θ`) the comparison `0`-cochain\
  \ on `\U0001D4B2`, with\n* **(N1)** (`witness`): `θ x ⋅ (u₁^♯ γ)(x,y) = (u₂^♯ γ)(x,y)\
  \ ⋅ θ y` on the pairwise\n  overlaps of `\U0001D4B2` — `θ` cobounds the two coprojection\
  \ pullbacks of `γ`, realizing the\n  descent equation `u₁^* L = u₂^* L` at the cochain\
  \ level; and\n* **(N2)** (`normalized`): `(s_q^♯ θ)(y) ⋅ (q₂^♯ ρ)(y) = (q₁^♯ ρ)(y)`\
  \ for every point\n  `y` of `Spec (B ⊗[A] B)`, on the canonical cover `Over.normalizationCover`\
  \ — the\n  σ-restriction of `θ` *is* the ρ-comparison `q₁^♯ ρ / q₂^♯ ρ`.  This is\
  \ the ρ-relative\n  normalization (see the module docstring for why \"σ-restriction\
  \ is `1`\" is not the\n  correct cochain-level statement); the σ-defect `s_q^♯ θ\
  \ ⋅ (q₂^♯ ρ / q₁^♯ ρ)` of the\n  packaged datum is `1` on the nose.\n\nThe triple-product\
  \ coherence **(N3)** — the three coface pullbacks of `θ` to the curve\nover `B ⊗[A]\
  \ (B ⊗[A] B)` satisfy `(w₂₃^♯ θ) ⋅ (w₁₂^♯ θ) = w₁₃^♯ θ`, in the exact face\nconvention\
  \ of `Module.IsDescentCocycle` — is **not** a field: it is a consequence of\n(N1)\
  \ + (N2) for a proper, geometrically irreducible and geometrically reduced curve\n\
  (`NormalizedCechComparison.coherent`, `AlgebraicJacobian.Picard.ComparisonCoherence`),\n\
  by Kleiman's `lm:aut` argument.  Existence (`Over.exists_normalizedCechComparison`)\n\
  requires no geometric hypotheses at all beyond `hrig` and `hdesc`."
file: AlgebraicJacobian/Picard/NormalizedComparison.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.NormalizedCechComparison
type: lean
updated: '2026-07-30T15:28:01'
---
structure NormalizedCechComparison (𝒩 : (XB).PointedCover)
    (γ : (XB).unitsCocycle 𝒩) : Type u where
  /-- The trivializing `0`-cochain of the section-pullback of `γ`, on the pullback cover
  `𝒩.pullback s_B` of `Spec B`. -/
  sectionTriv : ∀ b : SB, Γ(SB, (𝒩.pullback (sB)).opens b)ˣ
  /-- `sectionTriv` trivializes `s_B^♯ γ`: `ρ b ⋅ (s_B^♯ γ)(b,b') = ρ b'` on pairwise
  overlaps. -/
  sectionTriv_rel : ∀ b b' : SB,
    (SB).unitsRestrict
        (inf_le_left :
          (𝒩.pullback (sB)).opens b ⊓ (𝒩.pullback (sB)).opens b'
            ≤ (𝒩.pullback (sB)).opens b) (sectionTriv b)
      * (sB).unitsAppLE (𝒩.opens ((sB).base b) ⊓ 𝒩.opens ((sB).base b'))
          ((𝒩.pullback (sB)).opens b ⊓ (𝒩.pullback (sB)).opens b')
          ((sB).le_preimage_inf inf_le_left inf_le_right)
          (Scheme.unitsEvInf γ ((sB).base b) ((sB).base b'))
    = (SB).unitsRestrict inf_le_right (sectionTriv b')
  /-- The pointed cover of the curve over the double base carrying the comparison. -/
  cover : (Xq).PointedCover
  /-- The cover refines the pullback of `𝒩` along the first coprojection. -/
  le_pullbackInl : cover ≤ 𝒩.pullback (u₁)
  /-- The cover refines the pullback of `𝒩` along the second coprojection. -/
  le_pullbackInr : cover ≤ 𝒩.pullback (u₂)
  /-- The comparison: a unit `0`-cochain on the cover. -/
  θ : ∀ x : Xq, Γ(Xq, cover.opens x)ˣ
  /-- **(N1)**: `θ` cobounds the two coprojection pullbacks of `γ`:
  `θ x ⋅ (u₁^♯ γ)(x,y) = (u₂^♯ γ)(x,y) ⋅ θ y` on the pairwise overlaps of the cover. -/
  witness : ∀ x y : Xq,
    (Xq).unitsRestrict
        (inf_le_left : cover.opens x ⊓ cover.opens y ≤ cover.opens x) (θ x)
      * (u₁).unitsAppLE (𝒩.opens ((u₁).base x) ⊓ 𝒩.opens ((u₁).base y))
          (cover.opens x ⊓ cover.opens y)
          ((u₁).le_preimage_inf (inf_le_left.trans (le_pullbackInl x))
            (inf_le_right.trans (le_pullbackInl y)))
          (Scheme.unitsEvInf γ ((u₁).base x) ((u₁).base y))
    = (u₂).unitsAppLE (𝒩.opens ((u₂).base x) ⊓ 𝒩.opens ((u₂).base y))
          (cover.opens x ⊓ cover.opens y)
          ((u₂).le_preimage_inf (inf_le_left.trans (le_pullbackInr x))
            (inf_le_right.trans (le_pullbackInr y)))
          (Scheme.unitsEvInf γ ((u₂).base x) ((u₂).base y))
      * (Xq).unitsRestrict inf_le_right (θ y)
  /-- **(N2)**: the σ-restriction of `θ` is the ρ-comparison —
  `(s_q^♯ θ)(y) ⋅ (q₂^♯ ρ)(y) = (q₁^♯ ρ)(y)` on the normalization cover. -/
  normalized : ∀ y : Sq,
    (sq).unitsAppLE (cover.opens ((sq).base y))
        ((Over.normalizationCover C σ 𝒩 cover).opens y)
        (Over.normalizationCover_le_section C σ 𝒩 cover y) (θ ((sq).base y))
      * (q₂).unitsAppLE ((𝒩.pullback (sB)).opens ((q₂).base y))
          ((Over.normalizationCover C σ 𝒩 cover).opens y)
          (Over.normalizationCover_le_inr C σ 𝒩 cover y) (sectionTriv ((q₂).base y))
    = (q₁).unitsAppLE ((𝒩.pullback (sB)).opens ((q₁).base y))
        ((Over.normalizationCover C σ 𝒩 cover).opens y)
        (Over.normalizationCover_le_inl C σ 𝒩 cover y) (sectionTriv ((q₁).base y))