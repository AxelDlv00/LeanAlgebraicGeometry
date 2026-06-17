# Iter-210 objectives — per-task detail

## Lane TS — `Picard/TensorObjSubstrate.lean` — gate cleared, realization corrected, dispatch DEFERRED to 211

**Goal:** build the ⊗-invertibility line-bundle group law (the A.1.c.SubT spine root).
Gate CLEARED this iter (analogist ts-assoc-gate210): the associator IS buildable on the
invertible subcategory without `MonoidalClosed`. **Realization corrected** to (2)
flat-exactness whiskerLeft; (1) local-trivialization rejected (renamed wall). Blueprint
re-fixed this iter (corrective writer ts-engine210b); fresh review owed → dispatch iter-211.

**Associator realization (2) — the analogist's recipe (`analogies/ts-assoc-gate210.md`):**
With `a = PresheafOfModules.sheafification`, `η = toSheafify` (in `J.W`), `α` the presheaf
associator (Mathlib `PresheafOfModules.monoidalCategory`), for ⊗-invertible (hence flat)
`M,N,P`:
`(M⊗N)⊗P = a(a(M.val⊗ᵖN.val).val ⊗ᵖ P.val)`
`≅[a(η◁P), P flat] a((M.val⊗ᵖN.val)⊗ᵖP.val) ≅[a.mapIso α] a(M.val⊗ᵖ(N.val⊗ᵖP.val))`
`≅[a(M▷η), M flat] a(M.val ⊗ᵖ a(N.val⊗ᵖP.val).val) = M⊗(N⊗P)`.
Single load-bearing lemma: the **flat-whiskering bridge** `J.W g → J.W (F◁g)` for flat `F`.
Ingredients (all present Mathlib, LSP-verified): `Module.Flat.lTensor_preserves_injective_linearMap`,
`J.WEqualsLocallyBijective`, `GrothendieckTopology.instIsLocallyInjectiveToSheafify`,
`Module.Invertible ⇒ Projective ⇒ Module.Flat.of_projective`. Local surjectivity of `F◁g`
= right-exactness of `⊗`. Est. ~30–80 LOC for the bridge; NOT a multi-file build.

**New declarations to introduce (iter-211, matching blueprint `\lean{}`):**
`IsInvertible` (`def:scheme_modules_isinvertible`); the flat-whiskering bridge lemma;
`tensorObj_assoc_iso` (`lem:tensorobj_assoc_iso`, realization 2); `tensorObj_left_unitor` /
`tensorObj_right_unitor` (`lem:tensorobj_unit_iso`); `tensorObj_comm_iso`
(`lem:tensorobj_comm_iso`); `tensorObj_inverse_invertible`
(`lem:tensorobj_inverse_invertible`); `tensorObjIsoclassCommMonoid`
(`lem:tensorobj_isoclass_commgroup`).

**Proof regimes:** mechanical — `IsInvertible` def, unitors + braiding
(`sheafification.mapIso`); moderate — the flat-whiskering bridge + `tensorObj_assoc_iso`
(realization 2), and the `Units(Skeleton)`-shaped CommMonoid assembly.

**Leave as-is (off-path, demoted):** `monoidalCategory := sorry`, `tensorObj_restrict_iso`,
`exists_tensorObj_inverse`, `addCommGroup_via_tensorObj`. Note `tensorObj_isLocallyTrivial`
currently routes through the sorry'd `tensorObj_restrict_iso` (so it carries `sorryAx`); it
is NOT a clean precedent and is off the realization-(2) path.

**Pre-committed reversal:** if the flat-whiskering bridge `J.W g → J.W(F◁g)` itself bottoms
out in `MonoidalClosed`/strong-monoidal pushforward (analogist judged it should not), pause
TS, pivot focus to the Quot engine.

## Reference anchors (USER directive #3)
- `analogies/ts-assoc-gate210.md`, `analogies/ts-design206.md`.
- Mathlib `CommRing.Pic` / `Module.Invertible` (`Mathlib.RingTheory.PicardGroup`);
  `PresheafOfModules.monoidalCategory`; `Module.Flat.*` (`Mathlib.RingTheory.Flat.Basic`).
- Stacks 01CS (invertible module), 0B8K (`∃N` characterisation), 01CX (Picard group).
