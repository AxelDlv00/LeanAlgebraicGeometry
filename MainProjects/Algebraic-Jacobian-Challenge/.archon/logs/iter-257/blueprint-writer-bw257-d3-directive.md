# blueprint-writer bw257-d3 — fix `Picard_TensorObjSubstrate.tex` (D3′ realign + dual Step-4 sharpen)

Edit ONLY `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`. Two corrections + one housekeeping.
Do NOT add or remove any `\leanok`/`\mathlibok` marker.

## Correction 1 (MUST-FIX) — realign D3′ `lem:pullback_tensor_map_basechange` statement to the GENERAL form

The Lean decl `AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_restrict` does NOT prove the
base-change-square specialization currently written in the chapter. It proves the **general composition
coherence** of the sheaf-level pullback tensorator δ (`pullbackTensorMap`, `f^*(M⊗N) → f^*M ⊗ f^*N`) for
ANY two composable scheme morphisms `h : Z ⟶ Y`, `f : Y ⟶ X` and `M N : X.Modules`:

  pullbackTensorMap (h ≫ f) M N
    = (pullbackComp h f).inv.app (M ⊗ N)
      ≫ (pullback h).map (pullbackTensorMap f M N)
      ≫ pullbackTensorMap h (f^*M) (f^*N)
      ≫ (tensorObjIsoOfIso ((pullbackComp h f).app M) ((pullbackComp h f).app N)).hom

Rewrite the STATEMENT of `lem:pullback_tensor_map_basechange` to assert exactly this general composition
coherence (δ for the composite `h ≫ f` factors through the δ's for `f` and `h` conjugated by the pullback
pseudofunctoriality iso `pullbackComp h f`). Keep the existing `\label` and `\lean{}` pin. Then add a
short remark that the base-change-square form (`f∘j' = j∘g`, `j,j'` open immersions) used elsewhere is
the SPECIALIZATION `h := j'` obtained by equating the two factorisations — i.e. the general lemma implies
the square form as a corollary. (Optionally state that corollary as a separate `\lemma`/`\corollary` block
with its own label if a downstream `\uses` needs the square form by name; otherwise the remark suffices.)

## Correction 2 (MUST-FIX) — replace the disproven proof sketch with the 4-square comp_δ route

The current proof sketch ("proved by the same mate calculus as `lem:pullbackObjUnitToUnit_comp`",
`homEquiv.injective` + `conjugateEquiv_pullbackComp_inv`) is DISPROVEN: `pullbackTensorMap` is NOT an
adjunction transpose (it is a hand-built 4-fold composite `S1 ≫ a.map δ ≫ S3 ≫ S4` =
sheafificationCompPullback / oplax δ / sheafifyTensorUnitIso / pullbackValIso-tensor), so the mirror's
`homEquiv.injective` opening leaves an un-evaluable transpose and stalls. Replace the proof sketch with
the genuine **four-square composition-coherence** route (mirror of D1′'s 4-square *naturality* paste,
but for *composition*). State, in mathematical prose:

- Open with `simp [pullbackTensorMap]` to expose both sides as the 4-fold composite; the identity to
  prove is then a paste of four commuting squares conjugated by `pullbackComp h f`.
- **Sq2 (the δ core).** Decompose `δ` of the composite pullback via the Mathlib oplax-monoidal coherence
  `CategoryTheory.Functor.OplaxMonoidal.comp_δ`, after identifying the composite presheaf pullback
  `pullback φ'_{h≫f}` with `pullback φ'_f ⋙ pullback φ'_h` through the Mathlib presheaf coherence
  `PresheafOfModules.pullbackComp`. PREREQUISITE: the ring-map reconciliation
  `(toRingCatSheafHom (h≫f)).hom = φ'_f ≫ (Opens.map f.base).op.whiskerLeft φ'_h`, which is non-trivial
  because the two sides live in defeq-but-not-syntactic functor categories (`Opens.map (h.base ≫ f.base)
  = Opens.map f.base ⋙ Opens.map h.base` only up to `Opens.map_comp`, needing `eqToHom`/pseudo-functor
  transport). Bookkeeping atoms: `PresheafOfModules.{pullbackId, pullback_assoc, pullback_comp_id,
  pullback_id_comp}`.
- **Sq1.** Composition coherence of `SheafOfModules.sheafificationCompPullback` across `h ≫ f` — a NEW
  project sub-lemma (Mathlib-absent, ~40–80 LOC, mate-calculus style). Name it as a deferred sub-lemma.
- **Sq3.** `sheafifyTensorUnitIso` carried through the same `pullbackComp` identification.
- **Sq4 (the connecting iso).** Scheme-level composition coherence of `pullbackValIso` relating
  `pullbackValIso (h≫f) M` to `(pullback h).map (pullbackValIso f M)`, `pullbackValIso h (f^*M)`, and
  `(pullbackComp h f).app M` — a second NEW project sub-lemma (Mathlib-absent, ~40–80 LOC), producing the
  final `tensorObjIsoOfIso (pullbackComp h f) (pullbackComp h f)`.

State explicitly that Sq1 and Sq4 are the two genuine missing ingredients (to be built as standalone
sub-lemmas), and that `conjugateEquiv_pullbackComp_inv` is the adjunction-mate bridge used inside Sq2/Sq4.
Remove the misleading "same mate calculus as pullbackObjUnitToUnit_comp" framing entirely; you may add one
sentence noting WHY the mirror fails (not a transpose) so a future reader does not retry it.

## Correction 3 (housekeeping) — sharpen the `dual_restrict_iso` Step-4 leg-(A) sketch + fix stale status note

(a) The `lem:dual_restrict_iso` proof sketch already names leg (A) (slice-site transport) and leg (B)
(`restrictScalarsRingIsoDualEquiv`). Add ONE concise paragraph naming the leg-(A) atom now pinned by a
Mathlib-analogist consult (`analogies/dualstep4-257.md`): the slice transport `sliceDualTransport` is
built from the Hom-set bijection `CategoryTheory.Functor.FullyFaithful.homEquiv` of the fully-faithful
open-immersion functor `f.opensFunctor`, realised — because `Opens X` / `Over V` are THIN posets — as an
`eqToHom`-conjugation of the slice-Hom components along the down-set identity `image_preimage_of_le`
(`W.ι ''ᵁ (W.ι ⁻¹ᵁ V) = V`), with naturality discharged by `Subsingleton.elim`, wrapped in
`PresheafOfModules.isoMk` (exactly the pattern of the closed `homLocalSection` / `dualUnitIsoGen`). Then
the residual is `isoMk` of (leg A `sliceDualTransport`) ≪ (leg B `restrictScalarsRingIsoDualEquiv`). Note
that the inverse-uniqueness shortcut (derive from `tensorObj_restrict_iso`) was checked and is NOT viable
(no `MonoidalCategory`/rigid structure on `PresheafOfModules`).

(b) Fix the stale module/status prose in the chapter (the block reading "TWO residuals (iter-254)" near
the top): D1′ is closed and `homOfLocalCompat` is closed; state the current residual set in
state-not-iter language (the chapter should not carry per-iteration narrative).

## Out of scope
Do NOT edit any other chapter. Do NOT touch D1′/D2′/STEP A/group-law/stalk-tensor prose (correct).
Do NOT add `\leanok`/`\mathlibok`. Keep all `% SOURCE`/`% SOURCE QUOTE` citation blocks intact.
