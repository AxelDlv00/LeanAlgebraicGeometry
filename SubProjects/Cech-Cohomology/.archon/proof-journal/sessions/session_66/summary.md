# Session 66 (iter-066) — summary

## Metadata
- **Real inline sorry: 9 → 6** (net −3). OpenImmersionPushforward `_comp` (4 sub-sorries) CLOSED; CSI Stub 5
  decomposed (1 sorry → 2 leaves), Stub 6 untouched.
- Build: GREEN (`lake build` of both prover modules EXIT 0, 8331 jobs). Headline closed decl axiom-clean.
- Lanes: 2 (`prove`). OpenImm = full closure; CSI = partial (framework built + 2 residual leaves).
- Remaining real holes: CSI `cechSection_complex_iso` (coreIso 1492, hcompat 1504) + `cechSection_contractible`
  (1585); CechAugmentedResolution 229; CechHigherDirectImage 780 (frozen P5b); CechAcyclic 110 (dead `affine`).

## Headline — the STRETCH `_comp` is CLOSED: open-immersion route fully done
`higherDirectImage_openImmersion_comp` (`R^k f_*(j_* H) ≅ R^k (j≫f)_* H`) is now sorry-free and kernel-clean
(`#print axioms` = `{propext, Classical.choice, Quot.sound}`, verified first-hand via `lean_verify`). All four
former sub-sorries closed. With iter-065's `_acyclic`, the **entire open-immersion pushforward route is done**;
the P5a consumer is unblocked.

The decisive unlock was `hacyc` (`j_* Iⁿ` is `f_*`-acyclic). The flawed blueprint route (Serre vanishing on the
non-affine `U∩f⁻¹V`) was already corrected last iter to the adjoint route, and the prover found the concrete
Lean incantation:
- `pullback j` framing (iso to `pullback j`) **abandoned** — not needed.
- UNLOCK: `unfold Scheme.Modules.restrictFunctor; exact inferInstanceAs (SheafOfModules.pushforward _).IsRightAdjoint`
  (plain `infer_instance` FAILS) ⟹ `restrictFunctor j` mono-preserving ⟹ `Injective.injective_of_adjoint
  (restrictAdjunction j)` ⟹ `pushforward j` preserves injectives ⟹ `Functor.IsRightAcyclic.ofInjective`.
- `eRes` = `gCosyzygyIsoCocycles` + `isoOfQuasiIsoAt` + `isoHomologyπ₀` (augmentation, bypasses `R^0 j_* ≅ j_*`).
- `hexact` = `isoRightDerivedObj` + the iter-065 `_acyclic`.
- `transport` = `NatIso.mapHomologicalComplex (pushforwardComp j f)` (LHS defeq).

## CSI Stub 5 — augmentation framework built, reduced to 2 leaves
The prover built three sorry-free reusable helpers for promoting degreewise data to augmented-complex isos:
- `mapHC_augment_iso` (1374): applying an additive functor `Φ` commutes with augmenting a complex
  (`isoOfComponents` all `Iso.refl`, `comm` by `simp [CochainComplex.augment]`).
- `augmentCochainIso` (1405): augmented-complex iso from base iso `φ` + augmentation-object iso `eY` + compat
  square (degree-0 = `eY`, degree-(n+1) = `isoApp φ n`, `comm` via `φ.hom.comm`).
- `map_augment_cond` (1394): augmentation condition survives an additive functor (`change` + `← Functor.map_comp`).

With these, `cechSection_complex_iso` peels the augmentation (two `mapHC_augment_iso` + `augmentCochainIso`),
its outer body sorry-free, `eY := Iso.refl _` (the `restrictScalars (𝟙·) ⋙ toPresheaf` adapter is transparent).
The two residual leaves: **`coreIso`** (1492, the non-augmented degreewise iso — `pushPull_eval_prod_iso` for
objects + `sectionCech_objD_apply` for the differential) and **`hcompat`** (1504, the degree-0 compat square,
depends on `coreIso`). Stub 6 `cechSection_contractible` was not attempted this iter.

### Lean traps recorded (CSI augmentation framework)
- `Φ.Additive` does NOT resolve via `inferInstance` under a `set Ψ := …`-abstracted functor — thread it as an
  **explicit** argument `(hΦ : Φ.Additive)` + `haveI := hΦ`.
- The augmentation-zero condition needs `change Φ.map f ≫ Φ.map (C.d 0 1) = 0` to expose the map-composite
  BEFORE `rw [← Functor.map_comp, w, Φ.map_zero]` (bare `rw`/`simp only [mapHomologicalComplex_obj_d, …]` stalls).
- `isoApp` projection: parenthesize `(HomologicalComplex.Hom.isoApp φ 0).hom`, not `isoApp φ 0 |>.hom`.

## Soundness — confirmed, no papering
- First-hand: `lake build` EXIT 0; `lean_verify higherDirectImage_openImmersion_comp` = `{propext,
  Classical.choice, Quot.sound}` (no `sorryAx`). CSI sorry warnings exactly at the 2+1 honest leaves.
- **lean-auditor iter066** (`task_results/lean-auditor-iter066.md`): 0 must-fix / 2 major / 2 minor. Both
  OpenImm closures GENUINE — `hacyc` adjoint route real, `eRes`/`hexact`/`transport` all honest lemma chains, no
  thin-cat `Subsingleton.elim`/`congr` kernel collapse. CSI helpers clean; the 3 open CSI sorries honestly typed.
  The 2 majors are STALE `.lean` COMMENTS (877–896 + 956–966) that call closed cases "remaining"/"handed off"
  and misdescribe `hacyc` as Serre-vanishing — cleanup, not unsoundness.
- **lvb-openimm iter066** (`task_results/lean-vs-blueprint-checker-openimm-iter066.md`): 0 must-fix; `_comp`
  faithfully follows the rewritten adjoint blueprint, zero stale Serre-vanishing prose in the chapter.
- **lvb-csi iter066** (`task_results/lean-vs-blueprint-checker-csi-iter066.md`): 0 must-fix; all tagged decls
  match; Stub 6 blueprint sketch ADEQUATE; `hcompat` sketch THIN (advisory).

## Blueprint markers updated (manual)
- `Cohomology_CechHigherDirectImage.tex`, `lem:open_immersion_pushforward_acyclic`: added `% NOTE:` — the block
  is sorry-free since iter-065 but lacks `\leanok` because its `\lean{}` lists the **private**
  `isAffineHom_of_affine_separated` (name-mangled, unresolvable by `sync_leanok`). Fix = un-`private` the helper
  or drop it from `\lean{}`.
- `Cohomology_CechHigherDirectImage.tex`, `lem:jshriek_transport_along_iso`: added `% NOTE:` — same root cause
  (private `sectionsCorep`/`sectionsCorepPushforward` in `\lean{}`), `\leanok` missing ~6 iters.
- No `\mathlibok` added (all new decls are project proofs, not Mathlib re-exports). No stale `\notready` found.

## Notes (LOW)
- `sync_leanok` ran this iter (sha `46c28a4`, +16/−0). The two missing-`\leanok` blocks above are NOT laundering
  — the decls are genuinely closed; the markers are blocked by private names in `\lean{}` (sync artifact).
- blueprint-doctor: no findings.
- `dag-query unmatched` = 4: dead `CechAcyclic.affine` + 3 new CSI helpers (`mapHC_augment_iso`,
  `augmentCochainIso`, `map_augment_cond`) — coverage debt, listed in `recommendations.md`.

## Recommendations for next session
See `recommendations.md`. Headline: CSI is the sole live frontier — dispatch `coreIso`+`hcompat` (Stub 5) and
`cechSection_contractible` (Stub 6). Clean the 2 stale OpenImm comments + un-private the 3 helpers (one prover
pass). Blueprint-writer: cover the 3 new CSI helpers + thicken the `hcompat` sketch.
