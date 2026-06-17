# Session 37 (iter-037) — review summary

## Metadata
- **Sorry count:** 2 → 2 (no regression). Both frozen/superseded (`CechAcyclic.affine` dead;
  `CechHigherDirectImage.lean:~679` frozen P5b). Both prover files 0-sorry.
- **Build:** GREEN. `QcohRestrictBasicOpen.lean` + `QcohTildeSections.lean` both `lake env lean … EXIT 0`,
  diagnostics empty; all 7 new decls `lean_verify` axiom-clean `{propext, Classical.choice, Quot.sound}`.
- **Lanes planned 2, ran 2** (both `mathlib-build`). **+7 axiom-clean decls** (Lane A +5, Lane B +2);
  0 new sorries.
- `archon dag-query`: **gaps = 0**, **unmatched = 6** (1 pre-existing dead `CechAcyclic.affine` + 5 new
  helpers: 4 `overEquivalence` continuity decls + private `coversTop_iSup_eq_top`).
- `sync_leanok`: ran for iter 37 (`sha 4f578c3`, +18 / −0 on `Cohomology_CechHigherDirectImage.tex`).
- `blueprint-doctor`: **no structural findings** (all chapters `\input`'d, all `\ref`/`\uses` resolve,
  no `axiom` decls).

## Headline — both Route B sub-bricks (B1 + B2) landed; a Mathlib TODO closed as a byproduct
This iter executed the iter-037 plan's CHURNING corrective (build the bridge incrementally rather than
re-attempt the absent keystone). Two independent lanes, both COMPLETE:

- **Lane A `QcohRestrictBasicOpen.lean` — B2 + the `overEquivalence` continuity gateway (+5 axiom-clean).**
  `presentationOverBasicOpen` (B2: restrict a presentation of `M.over U` to `M.over D(g)` when
  `D(g) ⊆ U`, via `pushforwardPushforwardEquivalence (Over.iteratedSliceEquiv W)` +
  `Presentation.map`/`ofIsIso`), plus the four declarations
  `Opens.overEquivalence_{functor,inverse}_{coverPreserving,isContinuous}` that **close a documented
  Mathlib `## TODO`** (continuity of `TopologicalSpace.Opens.overEquivalence` both ways). The four
  continuity bricks are the gateway B3's `pushforwardPushforwardEquivalence` instantiation requires.
- **Lane B `QcohTildeSections.lean` — B1 (+2 axiom-clean).** `qcoh_finite_presentation_cover`
  (from `[F.IsQuasicoherent]`, refine the quasi-coherence cover to a finite standard cover `D(g_j) ⊆
  U_{φ(j)}` with `span{g_j} = ⊤`, each carrying a presentation), plus the project-local helper
  `coversTop_iSup_eq_top` (`CoversTop` on opens ⇒ `⨆ = ⊤`; no Mathlib equivalent).

The named keystone `qcoh_section_isLocalizedModule` was correctly left ABSENT (mathlib-build no-sorry
invariant) — it is gated to a future iter pending the B3/B4 import. This is the de-churning the planner
intended: the route stopped accumulating bridge helpers around an absent keystone and instead closed two
of its named sub-targets.

## Per-target detail

### B1 `qcoh_finite_presentation_cover` (Lane B) — SOLVED
- Statement: `[F.IsQuasicoherent] → ∃ (q : QuasicoherentData.{u,u,u,u} F) (n) (g : Fin n → R) (φ), …`.
- Proof pipeline (matches blueprint + `analogies/bridge.md` B1): `hF.nonempty_quasicoherentData` → `q`;
  `coversTop_iSup_eq_top q.X q.coversTop` → `⨆ q.X = ⊤`; `exists_finite_basicOpen_subcover` (DONE B0) →
  finite `g, φ`.
- **Universe / scope traps** (record for the keystone consumer): `IsQuasicoherent` is not in scope
  unqualified — use **dot notation `[hF : F.IsQuasicoherent]`** (resolves AND infers module universe `u`).
  Pin the existential to `QuasicoherentData.{u,u,u,u}` — otherwise Lean autobinds a fresh index universe
  for the `∃` that fails to unify with the instance's `u` (`.{u_1,u,u,u}` vs `.{u,u,u,u}`).

### B2 `presentationOverBasicOpen` (Lane A) — SOLVED
- Mirrors Mathlib `SheafOfModules.QuasicoherentData.bind`'s presentation field. Five elaboration traps,
  all worth reusing for B3/B4 (same engine):
  1. **IsContinuous-literal:** write the equiv-codomain ring sheaf with `W.left` LITERALLY
     (`(R := (Spec R).ringCatSheaf.over W.left)`), NOT the reduced `specBasicOpen g` — the instance
     `Over.iteratedSliceForward.IsContinuous … (J.over f.left)` matches on `f.left` syntactically.
  2. **`Presentation.ofIsIso` universe pin:** `Presentation.ofIsIso.{u,u,u}` (else the
     `[HasSheafify (J.over …)]` args resolve `AddCommGrpCat.{0}` → `Type 1` vs `Type (u+1)` mismatch).
  3. **counit `preimageIso` needs B pinned:** explicit `letI iso : e.inverse.obj (…) ≅ M.over W.left :=
     e.fullyFaithfulFunctor.preimageIso (by exact e.counitIso.app (…))`.
  4. `set_option backward.isDefEq.respectTransparency false in` before the def (bridges the
     `e.functor.obj (M.over W.left) =?= (M.over U).over W` defeq, only visible at all-transparency).
  5. `show (M.over W.left).Presentation from …` bridges body to the declared return type.

### `overEquivalence` continuity (Lane A) — SOLVED, closes a Mathlib TODO
- `Functor.IsCoverDense.isContinuous` (3 explicit args `J K G`) on the `CoverPreserving` witnesses;
  `IsCoverDense`/`IsLocallyFull`/`IsLocallyFaithful` auto-derived from the equivalence-of-sites
  instances. The auditor confirmed these are **not circular** (separate prior `CoverPreserving` decls).

### B3 `overBasicOpenIsoRestrict` / B4 `presentationModulesRestrictBasicOpen` — BLOCKED (clean stop)
- B3 is the single load-bearing bridge. The site-equivalence half is now CONTINUOUS both ways (the 4 new
  decls), so B3's `pushforwardPushforwardEquivalence` IsContinuous obligations are discharged. The
  **remaining genuine work = the ring-sheaf compatibility datum `φ/ψ/H₁/H₂`** built from the
  open-immersion `(specBasicOpen g).ι.appIso` (the same `appIso` `Scheme.Modules.restrictFunctor` uses) —
  real geometric content, NOT `map_id`-trivial. Prover decomposed it into B3a/B3b/B3c (see
  `recommendations.md`). B4 is mechanical given B3.

## Subagent reviews (all returned this iter, no must-fix)
- **lean-auditor `iter037`** (0 critical / 2 major / 4 minor): the two major items are comment-only —
  (1) stale docstring at `QcohRestrictBasicOpen.lean:31` claims `CompatiblePreserving` drives the
  equivalence continuity (the real driver is `IsLocallyFull`+`IsLocallyFaithful`); (2) the
  `set_option backward.isDefEq.respectTransparency false` at line ~126 has no companion comment
  explaining the defeq gap it bridges. Both planner/refactor-actionable, no correctness defect.
  Report: `.archon/task_results/lean-auditor-iter037.md`.
- **lean-vs-blueprint-checker `qrbo`** (10 decls, 0 red flags, 0 must-fix): 3 major blueprint-adequacy
  gaps — the 4 `overEquivalence` decls have no blueprint block; B2's `\uses` omits
  `pushforwardPushforwardEquivalence` + `Presentation.ofIsIso`; B3's sketch lacks the B3a/B3b/B3c
  decomposition. Report: `.archon/task_results/lean-vs-blueprint-checker-qrbo.md`.
- **lean-vs-blueprint-checker `qts`** (13 decls, 0 red flags, 0 must-fix): B1 faithful incl. the universe
  pin; `coversTop_iSup_eq_top` coverage debt; and a flagged **`\leanok`-sync issue** —
  `isLocalizedModule_of_span_cover` (P1b, iter-032) still lacks its proof `\leanok`, likely because
  `sync_leanok` cannot resolve the 7 private helper names bundled into its `\lean{...}` list. Planner
  should investigate. Report: `.archon/task_results/lean-vs-blueprint-checker-qts.md`.

## Blueprint markers updated (manual)
- `Cohomology_CechHigherDirectImage.tex`, `lem:qcoh_finite_presentation_cover`: stripped stale
  `% NOTE: to-build (Route B, step B1).` (block is now formalized + `\leanok` by sync).
- `Cohomology_CechHigherDirectImage.tex`, `lem:presentation_over_basicOpen`: stripped stale
  `% NOTE: to-build (Route B, step B2).` (block is now formalized + `\leanok` by sync).
- No `\mathlibok` added: the 4 `overEquivalence` continuity decls are project theorems with genuine
  proofs (they CLOSE a Mathlib TODO), not Mathlib re-exports — they need real blueprint blocks
  (coverage debt, listed in `recommendations.md`), not `\mathlibok`.
- No `\leanok` touched. No `\lean{...}` renames (B1/B2 names match their pins). B3/B4/keystone
  `% NOTE: to-build` left in place (still unformalized).

## Key findings / patterns
- **`pushforwardPushforwardEquivalence` engine reuse:** B2 validated the full elaboration recipe (5
  traps). B3 reuses the same engine but with a NON-trivial ring-sheaf comparison (`appIso`), which is the
  genuine remaining content of Route B.
- **De-churning by sub-target closure:** the planner's response to the iter-037 CHURNING verdict —
  build the bridge's leaves rather than re-attempt the keystone — produced 2 named-target closures, the
  first since the route entered its current phase.

## Recommendations
See `recommendations.md`. Headline: next iter build B3a/B3b/B3c (the ring-sheaf compatibility datum) →
B4 → wire the import → assemble the keystone. Blueprint-writer first on B3's B3a/B3b/B3c decomposition +
the `overEquivalence` infra block; reviewer (planner) should look at the `isLocalizedModule_of_span_cover`
`\leanok`-sync issue.
