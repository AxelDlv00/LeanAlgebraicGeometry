# Iter-228 objectives detail

## Lane TS — `Picard/TensorObjSubstrate.lean` [mode: mathlib-build]

STUCK route (progress-critic ts228), bounded committed runway. C-bridge primary + A-engine
`localSection` secondary. Project sorry 80 (no close expected this iter).

### PRIMARY — C-bridge: `dual_isLocallyTrivial` FULL axiom-clean

Target: `AlgebraicGeometry.Scheme.Modules.dual_isLocallyTrivial` — the dual of a line bundle is a line
bundle (Stacks 01CR item 2). Blueprint `lem:dual_isLocallyTrivial` (proof sketch expanded iter-228).

Load-bearing ingredient — the restrict-iso `(dual M).restrict f ≅ dual(M.restrict f)` for an open
immersion `f`, built as a **VERBATIM MIRROR** of the CLOSED `tensorObj_restrict_iso` (`:~1848`):
- Steps 1–3 reused verbatim: `restrictFunctorIsoPullback` (restrict → pullback) →
  `sheafificationCompPullback` (pullback inside sheafification) → strip outer sheafification (`.mapIso`).
  Valid because `dual M` and `tensorObj M N` are both `sheafification.obj (presheaf-…)`.
- Presheaf residual closes by **H1** `pushforward β ≅ pullback φ` (`pushforwardPushforwardAdj` +
  `Adjunction.leftAdjointUniq`, reused verbatim) ∘ **H2′** = `restrictScalarsRingIsoDualEquiv` (`:306`,
  built iter-227) along the open-immersion ring iso `f.appIso`.
Then `dual_isLocallyTrivial` mirrors the CLOSED `tensorObj_isLocallyTrivial` (`:~1962`): on a
trivialising `U`, `(dual L)|_U ≅ dual(L|_U) ≅ ℋom(𝒪_U,𝒪_U) ≅ 𝒪_U` (eval-at-1).

d.2-free (C-probe ts227 = DECISIVE): no tensor stalk, no `M ◁ η` whiskering; `restrictScalars` along a
ring iso is an equivalence ⇒ commutes with `Hom(-,-)` in both variances despite `dual` contravariant.

Success bar (SHARPENED): `dual_isLocallyTrivial` closed, `lean_verify` =
`{propext, Classical.choice, Quot.sound}`, build GREEN. Helpers-only partial = NOT route progress.

### SECONDARY — A-engine sub-piece `localSection` (only if C lands + budget remains)

Standalone axiom-clean lemma: for each `i`, `localSection i : (presheafHom (M.val.presheaf)
(N.val.presheaf)).obj (op (Uᵢ))` from `fᵢ : M.restrict (Uᵢ).ι ⟶ N.restrict (Uᵢ).ι`. Component at
`(V, h : V ⟶ Uᵢ)` = `eqToHom`-conjugated `fᵢ.mapPresheaf` component via `(Uᵢ).ι ''ᵁ ((Uᵢ).ι ⁻¹ᵁ V) = V`
(`V ≤ Uᵢ`). The **naturality field** is the only real-coherence-risk sub-piece. Route:
`existsUnique_gluing` on the hom-presheaf-as-`TopCat.Sheaf` (sheaf via `Presheaf.IsSheaf.hom`,
needs `N.isSheaf`). Do NOT attempt full `homOfLocalCompat`; do NOT pin a sorry; hand off the next step.

### Reuse (do NOT re-derive)
`isIso_of_isIso_restrict` (B-connector), `tensorObj_restrict_iso` + `tensorObj_isLocallyTrivial`
(C mirror templates, CLOSED), `tensorObj_unit_iso`, `restrictScalarsRingIsoDualEquiv` + `homMk` +
`toPresheaf_map_homMk` (CLOSED iter-227), `Scheme.Modules.dual`, `pushforwardPushforwardAdj` apparatus.

### FORBIDDEN
NEW sorry pins; sheafify-the-presheaf-eval/associator shortcut (d.2 DEAD END); `isLocallyInjective_whiskerLeft_of_W`
(L659, vestigial d.2); sectionwise flatness; `addCommGroup_via_tensorObj`; `exists_tensorObj_inverse`
(assembly — needs C+A first); `maxHeartbeats`; `Sheaf.val`→`ObjectProperty.obj` migration.

### Recipe / blueprint
`analogies/ts226descent.md` (verdict D = d.2-FREE); `chapters/Picard_TensorObjSubstrate.tex`
(`lem:dual_isLocallyTrivial`, `lem:restrictscalars_ringiso_dualequiv`,
`lem:sheafofmodules_hom_of_local_compat`).
