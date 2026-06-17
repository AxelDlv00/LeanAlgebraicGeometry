# Recommendations — next plan iteration (post iter-066)

## Closest-to-completion / prioritize

1. **CSI `cechSection_complex_iso` — 2 residual leaves (`prove`).** Frontier-ready; the augmentation framework
   (`mapHC_augment_iso`/`augmentCochainIso`/`map_augment_cond`) is built sorry-free.
   - `coreIso` (line 1492): non-augmented degreewise iso `(GV.mapHC).obj (Ψ.mapHC.obj (cechComplexOnX 𝒰 F)) ≅
     sectionCechComplexV 𝒰 F V`. Objects via `pushPull_eval_prod_iso` (Stub 4, DONE); differential match via
     `sectionCech_objD_apply` (CechAcyclic.lean:1513) read through `sectionCechProductEquiv`. MEDIUM.
   - `hcompat` (line 1504): degree-0 augmentation-compat square; depends on `coreIso`; near-definitional once the
     `restrictScalars (𝟙·) ⋙ toPresheaf` adapter is unfolded. **Blueprint sketch is THIN here (lvb-csi minor)** —
     have the blueprint-writer add the adapter-unfold note BEFORE dispatch.

2. **CSI `cechSection_contractible` (Stub 6, line 1585) — `prove`.** Blueprint sketch ADEQUATE (lvb-csi). Dep*
   homotopy engine + degree-0 augmentation node (`π_{i_fix}` coordinate projection; documented risk = the engine
   covers degrees ≥1, so the degree-0 node needs the explicit `ε∘π_{i_fix} + engine-term = id` verification). If
   that node stalls, effort-break the node only.

   Both CSI leaves close `CechAugmentedResolution.hSec` (229) downstream. CSI is the **sole live frontier** —
   OpenImm is fully done; CechHigherDirectImage 780 is frozen P5b; CechAcyclic 110 is the dead `affine` route.

## MEDIUM — blueprint + housekeeping (cheap, do alongside CSI dispatch)

3. **Coverage debt — 3 new CSI helpers (`dag-query unmatched`).** No `\lean{}` blueprint entry:
   `mapHC_augment_iso` (CSI:1374), `augmentCochainIso` (CSI:1405), `map_augment_cond` (CSI:1394). All sorry-free.
   Blueprint-writer should add `\lean{}` blocks (lvb-csi rates the first two "major" — reusable infrastructure):
   "applying an additive functor commutes with augmenting a complex" / "augmented-complex iso from base iso +
   augmentation-object iso + compat square" / "augmentation condition survives an additive functor."

4. **Two STALE OpenImm `.lean` comments (lean-auditor major).** A prover (next OpenImm touch, or a quick cleanup
   pass) should fix — they misdescribe the now-closed proof:
   - `OpenImmersionPushforward.lean:877–896`: calls the closed `hjt`/`hqc` cases "remaining"/"unbuilt".
   - `OpenImmersionPushforward.lean:956–966`: calls closed `hexact`/`hacyc` "handed off" AND wrongly describes
     `hacyc` as "Serre-vanishing on U∩f⁻¹V" (actual proof is the `Injective.injective_of_adjoint` adjoint route).
   - (minor) the iter-065 "RESIDUAL STATE" block at 605–623 should note `_comp` is also closed now.

5. **Un-`private` 3 helpers to unblock `sync_leanok` (`\leanok` artifact).** Two sorry-free, axiom-clean blocks
   carry NO `\leanok` purely because their `\lean{}` lists `private` (name-mangled) helpers that `sync_leanok`
   cannot resolve: `lem:open_immersion_pushforward_acyclic` (`isAffineHom_of_affine_separated`) and
   `lem:jshriek_transport_along_iso` (`sectionsCorep`/`sectionsCorepPushforward`, missing ~6 iters). I added
   `% NOTE:` flags at both blocks. Cheapest fix: a prover drops `private` from those 3 helpers (preserves
   coverage AND lets next sync add the markers). Alternative = remove the private names from the `\lean{}` lists
   (loses coverage). Do NOT add `\leanok` manually.
   - (minor, optional) blueprint `lem:open_immersion_pushforward_comp` `\uses{}` lists two entries the Lean proof
     does NOT use: `lem:restrictFunctorIsoPullback_mathlib`, `lem:right_derived_zero_iso_self`. Trimming them
     tightens the dep graph (planner's call — over-declaration is harmless, just imprecise).

## Reusable proof patterns discovered

- **`pushforward j` preserves injectives** (adjoint route, the `hacyc` unlock): `unfold restrictFunctor; exact
  inferInstanceAs (SheafOfModules.pushforward _).IsRightAdjoint` (plain `infer_instance` FAILS) → mono-preserving
  → `Injective.injective_of_adjoint (restrictAdjunction j)` → `Functor.IsRightAcyclic.ofInjective`. Reusable for
  any "right adjoint of a mono-preserving functor preserves injectives → acyclic" obligation.
- **Functor-on-augmented-complex** = `mapHC_augment_iso` (all-`Iso.refl` components, `comm` by
  `simp [CochainComplex.augment]`); **augmented-complex iso assembly** = `augmentCochainIso`. Now reusable
  infrastructure for any augmented-complex transport.
- **`Φ.Additive` under `set`**: thread as explicit `(hΦ : Φ.Additive)` + `haveI := hΦ`; do NOT rely on
  `inferInstance` through a `set`-abstracted functor.

## Do NOT retry / dead

- `CechAcyclic.affine` (110): dead route, leave untouched.
- `CechHigherDirectImage` P5b (780): frozen protected signature.
- OpenImm `hacyc` via "Serre vanishing on U∩f⁻¹V": FLAWED (that open isn't affine) and now MOOT — the adjoint
  route is closed. Do not resurrect.
