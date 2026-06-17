# Iter-257 — detailed prover objectives

Three import-independent lanes (M=3). All recipes are pre-verified by this iter's analogist /
blueprint-writer / blueprint-reviewer passes. Blueprint chapters re-gated this iter (fast path).

---

## Lane TS-inv — `Picard/TensorObjSubstrate/DualInverse.lean` — CLOSE `dual_restrict_iso` Step-4

**Status going in:** 1 sorry (`dual_restrict_iso` Step-4, ~L259). `homOfLocalCompat` CLOSED iter-256.
This is the LAST substrate sorry feeding `exists_tensorObj_inverse` (the loc-triv⟹invertible bridge RPF
needs). pc257 = CONVERGING; sc257 = the dual arc is CONFIRMED on-path ("the dual of a line bundle is a
line bundle"; no carrier choice avoids it). pc256 deferred Step-4 pending a recipe — the recipe is now
in hand (`analogies/dualstep4-257.md`), so this lane is ARMED.

**Recipe (full skeleton in `analogies/dualstep4-257.md`; blueprint `lem:dual_restrict_iso` proof updated):**
The residual is the PresheafOfModules iso
`(pushforward β).obj (dual M.val) ≅ dual ((pushforward β).obj M.val)`, `β` the sectionwise open-immersion
ring iso. It decomposes as **leg (A)** slice transport ∘ **leg (B)** ring-iso codomain swap.

- **Route (1) inverse-uniqueness (derive from `tensorObj_restrict_iso`) is DEAD** — confirmed by the
  analogist: `hasRightDualOfEquivalence`/`rightDualIso` need 4 absent structures (no `MonoidalCategory`
  instance on `PresheafOfModules`, not strong-monoidal, not an equivalence, no `ExactPairing` for general
  M). Do NOT attempt it.
- **Build leg (A) `sliceDualTransport` as a standalone axiom-clean `def` FIRST**, mirroring the already-
  closed `homLocalSection` (L358): conjugate the slice-Hom components by `eqToHom` along the down-set
  identity `image_preimage_of_le` (L439, `W.ι ''ᵁ (W.ι ⁻¹ᵁ V) = V`), naturality by `Subsingleton.elim`.
  Signature (skeleton):
  ```
  sliceDualTransport (f) [IsOpenImmersion f] (M : X.Modules) (V : (Opens Y)ᵒᵖ) :
    (restr (f.opensFunctor.obj V.unop) M.val ⟶ restr (f.opensFunctor.obj V.unop) 𝟙_X)
      ≃ₗ[𝒪_Y(V.unop)]
    (restr V.unop ((pushforward β).obj M.val) ⟶ restr V.unop 𝟙_Y)
  ```
  = (A) Hom-set transport along the slice order-iso from `f.opensFunctor` (the `Functor.FullyFaithful.homEquiv`
  shape, but in the THIN poset it reduces to the `eqToHom`-conjugation) ∘ (B) `restrictScalarsRingIsoDualEquiv β_V`
  (project, CLOSED — the 𝒪_Y(V)-linear codomain-unit ring swap).
- **Assemble Step-4** via `PresheafOfModules.isoMk (fun V => (sliceDualTransport f M V).toModuleIso)`
  with thin-poset `Subsingleton.elim` naturality (as in `dualUnitIsoGen` / `dualIsoOfIso`).
- Atoms: `Functor.FullyFaithful.homEquiv` [verified — `Mathlib.CategoryTheory.Functor.FullyFaithful`],
  `image_preimage_of_le` (this file), `restrictScalarsRingIsoDualEquiv` (CLOSED), `PresheafOfModules.isoMk`.
  Do NOT route through `overSliceSheafEquiv` (Sheaf/fixed-value-cat — proven inapplicable) nor build a
  full `Over V ≌ Over fV` object.

**Bar:** build `sliceDualTransport` axiom-clean, then close `dual_restrict_iso` Step-4 (⇒ `dual_isLocallyTrivial`
becomes axiom-clean too). **Reversing signal:** if leg (A)'s `eqToHom`-conjugation does NOT reduce as in
`homLocalSection` (e.g. the slice-Hom value carries down-set compatibility beyond the thin-poset reduction),
STOP and report the exact failing step + the goal at that point; do NOT revive route (1), do NOT build a
heavyweight equivalence object. Leave `sliceDualTransport` as a scaffolded sorry if only the assembly is
reached. Stale L573–576 comment ("SOLE remaining sorry is the inner ring-bridge") should be removed on close.

---

## Lane TS-cmp — `Picard/TensorObjSubstrate.lean` — D3′ 4-square comp_δ build

**Status going in:** 2 sorries (`exists_tensorObj_inverse` L715 cross-file-gated, OFF-LIMITS;
`pullbackTensorMap_restrict` D3′ scaffold L2138). pc257 = CONVERGING. Blueprint `lem:pullback_tensor_map_basechange`
realigned this iter to the GENERAL composition coherence + 4-square route (br257-regate cleared).

**Recipe (blueprint `lem:pullback_tensor_map_basechange` proof, rewritten this iter; in-file ROADMAP at
L2147–2187):** The mirror of `pullbackObjUnitToUnit_comp` is DEAD (`pullbackTensorMap` is a hand-built
4-fold composite, not an adjunction transpose — do NOT use `homEquiv.injective`). The genuine route is a
4-square composition coherence (analog of D1′'s 4-square *naturality* paste):
- `simp [pullbackTensorMap]` exposes both sides as `S1 ≫ a.map δ ≫ S3 ≫ S4`.
- **Sq2 (δ-core):** `Functor.OplaxMonoidal.comp_δ` [verified Functor.lean] after identifying
  `pullback φ'_{h≫f} ≅ pullback φ'_f ⋙ pullback φ'_h` via `PresheafOfModules.pullbackComp` [verified].
  Prerequisite ring-map reconciliation `(toRingCatSheafHom (h≫f)).hom = φ'_f ≫ (Opens.map f.base).op.whiskerLeft φ'_h`
  (needs `Opens.map_comp` eqToHom transport; atoms `pullbackId/pullback_assoc/pullback_comp_id/pullback_id_comp`).
- **Sq1:** composition coherence of `SheafOfModules.sheafificationCompPullback` across `h≫f` — NEW
  standalone project sub-lemma (~40–80 LOC).
- **Sq3:** `sheafifyTensorUnitIso` carried through the same `pullbackComp`.
- **Sq4:** composition coherence of `pullbackValIso` — NEW standalone project sub-lemma (~40–80 LOC),
  producing the final `tensorObjIsoOfIso (pullbackComp h f) (pullbackComp h f)`.
- `conjugateEquiv_pullbackComp_inv` [verified] is the adjunction-mate bridge inside Sq2/Sq4. Reuse the
  D1′ `show…from` canonical-spelling device if `comp_δ` fails `MonoidalCategory` synthesis.

**Bar (pc257-set, realistic):** close Sq2 + at least one of Sq1/Sq4 as standalone sub-lemmas; assemble what
those allow; leave the remaining Sq as a scaffolded sorry with the exact failing step reported. A full
single-iter close is possible but not required. **Reversing signal:** if a Sq sub-lemma hits an unexpected
wall, leave the typed sorry + report the exact failing step — do NOT add another abstract helper layer.
Keep `exists_tensorObj_inverse` (L715) untouched; keep D1′/D2′ GREEN. The stale `.lean` status header is a
separate (auditor minor) item — optional cleanup, not load-bearing.

---

## Lane engine — `Picard/LineBundleCoherence.lean` — open the 5 bodies

**Status going in:** 5 sorry stubs; compiles; site instances ALL confirmed present (iter-256 de-risk).
Import added to `AlgebraicJacobian.lean` (refactor `add-lbc-import`, build green). pc257 = UNCLEAR (fresh,
positive readiness). Blueprint `Picard_LineBundleCoherence.tex` finiteness-bridge fixed + false `\leanok`
removed this iter (br257-regate cleared).

**Targets (blueprint proof sketches updated this iter):**
1. `exists_trivializing_cover` (L96) — near-trivial: repackage the pointwise `IsLocallyTrivial` existential
   into the indexed cover (`I := X` underlying points; `iSup U = ⊤`). Close.
2. `chart_free_rank_one` (L153) — near-trivial: `exact hM x` (it is `IsLocallyTrivial` unfolded at a point;
   the blueprint prose now honestly frames rank-one/flat as consequences of the iso, not separate type
   content). Close.
3. `chartPresentation` (L116) — build via `SheafOfModules.Presentation.ofIsIso e.hom` transporting the
   canonical finite free presentation of `SheafOfModules.unit (U).ringCatSheaf`; the `IsFinite` rides along
   as the automatic `ofIsIso` instance (NO separate 6th decl). [Recipe: blueprint `lem:lbc_chart_presentation`.]
4. `isFinitePresentation` (L130) — assemble `QuasicoherentData` from `exists_trivializing_cover` charts +
   `chartPresentation`; each chart's `IsFinite` is the automatic instance; feed `SheafOfModules.IsFinitePresentation.mk`
   (or anonymous `⟨⟨…⟩⟩`). [Recipe: blueprint `thm:lbc_isFinitePresentation`.]
5. `isFiniteType` (L139) — corollary: from `hM.isFinitePresentation` via the Mathlib
   `IsFinitePresentation → IsFiniteType` instance. (`IsQuasicoherent` is a free instance; not separately stated.)

**Bar:** close the two near-trivial decls (#1, #2) for sure; make real progress on `chartPresentation` +
`isFinitePresentation` (the finiteness-bridge recipe is now in the blueprint). Close `isFiniteType` if
`isFinitePresentation` lands. **Reversing signal:** if `Presentation.ofIsIso` or the `IsFinite` instance is
NOT actually present in the pinned Mathlib as the blueprint claims, STOP and report the exact missing
Mathlib name (→ a mathlib-build sub-step next iter); do NOT fake it with a typed pin. This is the engine's
first body-opening iter — partial progress with a precise blocker report is acceptable.
