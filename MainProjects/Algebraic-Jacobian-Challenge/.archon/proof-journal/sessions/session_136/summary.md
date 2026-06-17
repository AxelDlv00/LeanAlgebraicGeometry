# Session 136 — iter-136 review

## Metadata

- **Iteration**: 136 (review of iter-136 prover lane).
- **Stage**: prover (single-file lane on `AlgebraicJacobian/Cotangent/GrpObj.lean`).
- **Sorry count before iter-136**: 6 (per iter-135 close — `Cotangent/GrpObj.lean` 3, `Jacobian.lean` 2, `RigidityKbar.lean` 1).
- **Sorry count after iter-136**: **5** (−1 substantive closure on `Cotangent/GrpObj.lean:496` → now L508 → body closed).
- **Targets attempted**: 1 (`AlgebraicGeometry.GrpObj.relativeDifferentialsPresheaf_restrict_along_identity_section`).
- **Result**: SOLVED (RESOLVED in 4 attempts over ~25 min; ~27 LOC closure including a new ~5 LOC private helper).
- **Files edited**: `AlgebraicJacobian/Cotangent/GrpObj.lean` only (574 → 612 LOC; +38 LOC including 11 LOC of docstring updates and the new helper + body).

## Per-target detail

### `relativeDifferentialsPresheaf_restrict_along_identity_section` (`Cotangent/GrpObj.lean:508`) — SOLVED

**Goal at start (per `lean_goal` line 535):**

```
(PresheafOfModules.pullback (toRingCatSheafHom (snd G G).left).hom ⋙
  PresheafOfModules.pullback (toRingCatSheafHom (lift (𝟙 G) (toUnit G ≫ η)).left).hom).obj Ω ≅
(PresheafOfModules.pullback (toRingCatSheafHom G.hom).hom).obj
  ((PresheafOfModules.pullback (toRingCatSheafHom η.left).hom).obj Ω)
```

where `Ω = Scheme.relativeDifferentialsPresheaf G.hom`.

**Attempt 1 — helper insertion + 3-step body skeleton** (`section_snd_eq_identity_struct` placed before the `/--` of the consumer; body `iso1.trans sorry`).
- **Errors**: (i) `unexpected token '/--'; expected 'lemma'` — helper was inserted immediately before a `/--` docstring with no blank-line separator; (ii) residual unsolved goal `G.hom ≫ Over.Hom.left η = G.hom ≫ η.left` from the helper itself — the docstring uses `CommaMorphism.left η[G]` (the displayed RHS) while `η.left` is what the auto-elaboration produces; equal but not syntactically identical.
- **Fix**: move the helper after `schemeHomRingCompatibility` with a blank line, and add a trailing `rfl` to bridge `CommaMorphism.left η[G]` vs `η.left`.
- **Insight**: trailing `rfl` is the bridge between the human-named `CommaMorphism.left η[G]` and Lean's elaboration `η.left`.

**Attempt 2 — `iso1.trans (sorry.trans iso2.symm)` skeleton**.
- **Error**: `Unknown identifier '«sorry».trans'` — the literal `sorry` token cannot be used as a term inside a chained `.trans` in this slot.
- **Fix**: switch to `refine iso1 ≪≫ ?_ ≪≫ iso2.symm` — the `≪≫` notation accepts an underscore middle for `refine`, producing a clean intermediate iso goal.
- **Insight**: prefer `≪≫` + `refine ... ?_ ...` over `.trans ... .trans ...` when you need a hole in the middle of an iso composition.

**Attempt 3 — discharge middle iso via `eqToIso ?_ ; congr 2 ; simp only [← Opens.map_comp_eq, ...]`**.
- **Error**: `Tactic 'rewrite' failed: Did not find an occurrence of the pattern Opens.map ?g ⋙ Opens.map ?f in the target expression Opens.map ((Over.Hom.left ...).base)` — the `Opens.map` composition was not yet syntactically present; the inner pullback functors already collapse it via whisker.
- **Insight**: `Opens.map_comp_eq` is the wrong lever here — the `pullbackComp` natural iso has already commuted everything. The cleaner move is to `change` (not `congr`) the goal into a single-pullback form on each side.

**Attempt 4 — `change`-based reshape + single `rw`** ✅
```lean
refine iso1 ≪≫ ?_ ≪≫ iso2.symm
refine eqToIso ?_
change (PresheafOfModules.pullback
        (Scheme.Hom.toRingCatSheafHom
          ((lift (𝟙 G) (toUnit G ≫ η[G])).left ≫ (snd G G).left)).hom).obj
      (Scheme.relativeDifferentialsPresheaf G.hom) =
    (PresheafOfModules.pullback
        (Scheme.Hom.toRingCatSheafHom
          (G.hom ≫ (CategoryTheory.CommaMorphism.left η[G]))).hom).obj
      (Scheme.relativeDifferentialsPresheaf G.hom)
rw [section_snd_eq_identity_struct]
```
- **Insight (load-bearing)**: the combined compatibility morphism produced by `pullbackComp`,
  `(toRingCatSheafHom snd.left).hom ≫ whiskerLeft (Opens.map snd.left.base).op (toRingCatSheafHom lift.left).hom`,
  is **definitionally equal** to `(toRingCatSheafHom (lift.left ≫ snd.left)).hom`
  (by `Scheme.Hom.c` of a composition + `whiskerRight` distributing over `whiskerLeft`).
  `change` accepts this reshape without any rewriting, so the proof reduces to a pure
  scheme-morphism equality closed by the new helper `section_snd_eq_identity_struct`.
- **Prefer `change` over `show`** when the new form differs syntactically — the Lean linter
  warns on `show` for genuine shape changes (per session events L52 + L74).

### Helper introduced this iter — `section_snd_eq_identity_struct` (L452–L457; private, ~5 LOC)

```lean
private lemma section_snd_eq_identity_struct
    (G : Over (Spec (.of k))) [CategoryTheory.GrpObj G] :
    (lift (𝟙 G) (toUnit G ≫ η[G])).left ≫ (snd G G).left =
      G.hom ≫ (CategoryTheory.CommaMorphism.left η[G]) := by
  rw [← Over.comp_left, lift_snd, Over.comp_left, Over.toUnit_left]
  rfl
```

Captures the categorical identity `s ≫ pr_2 = η_G ∘ π_G` (at the underlying scheme level), via three rfl-level Mathlib lemmas (`Over.comp_left`, `lift_snd`, `Over.toUnit_left`) and a final `rfl` to bridge `CommaMorphism.left η[G]` vs Lean's auto-elaborated `η.left`. Minimal binders: only `(G : Over (Spec (.of k))) [GrpObj G]` (no `n` / `SmoothOfRelativeDimension` / `IsProper` / `GeometricallyIrreducible`).

## Compile state at iter-136 close

- `lean_diagnostic_messages` on `AlgebraicJacobian/Cotangent/GrpObj.lean`: 0 errors; 2 expected `declaration uses sorry` warnings (L488 = Step 2 scaffold; L610 = Main lemma scaffold). Both intentional iter-137+/iter-138+ targets.
- `lake env lean AlgebraicJacobian/Cotangent/GrpObj.lean`: green; only the two expected sorry warnings.
- `lean_verify AlgebraicGeometry.GrpObj.relativeDifferentialsPresheaf_restrict_along_identity_section`:
  `{"axioms":["propext","Classical.choice","Quot.sound"]}` — kernel-only, no `sorryAx`.
- Total active sorries: **5** (per direct grep on `AlgebraicJacobian/`):
  - `AlgebraicJacobian/Cotangent/GrpObj.lean:488` (`relativeDifferentialsPresheaf_basechange_along_proj_two`)
  - `AlgebraicJacobian/Cotangent/GrpObj.lean:610` (`mulRight_globalises_cotangent`)
  - `AlgebraicJacobian/Jacobian.lean:197` (`genusZeroWitness`, M2.b scaffold)
  - `AlgebraicJacobian/Jacobian.lean:223` (`positiveGenusWitness`, M3 user-escalation scaffold)
  - `AlgebraicJacobian/RigidityKbar.lean:87` (`rigidity_over_kbar`, M2.b scaffold)

## Mathlib lemmas consumed (iter-136)

| Lemma | Mathlib file | Role |
|---|---|---|
| `PresheafOfModules.pullbackComp` | `Mathlib.Algebra.Category.ModuleCat.Presheaf.Pullback:131` | Merge nested pullbacks on each side into a single composite-morphism pullback. |
| `Scheme.Hom.toRingCatSheafHom` | `Mathlib.AlgebraicGeometry.Modules.Presheaf:42` | The canonical compatibility morphism for `PresheafOfModules.pullback` along a scheme morphism (per iter-135 mathlib-analogist verdict; `analogies/phi-compatibility-morphisms.md`). |
| `Over.comp_left` | `Mathlib.CategoryTheory.Comma.Over.Basic:93` | `(f ≫ g).left = f.left ≫ g.left` (rfl-level). |
| `lift_snd` | (Cartesian monoidal) | `lift f g ≫ snd _ _ = g`. |
| `Over.toUnit_left` | `Mathlib.CategoryTheory.Monoidal.Cartesian.Over:81` | `(toUnit R).left = R.hom` (rfl). |
| `LocallyRingedSpace.comp_c` | (consumed via `rfl`-unfolding of `toRingCatSheafHom (f ≫ g)`; not invoked by name) | C-composition rule that makes the `change` accept the composite-pullback reshape. |

## Review-phase audits (subagent dispatches)

Both mandatory audits dispatched and returned cleanly.

- **`lean-auditor-review136`** (4.4 min / $2.37 / 22 turns; report: `task_results/lean-auditor-review136.md`). 13 files audited. Verdict: **0 must-fix / 0 major / 0 excuse-comments / 3 minor**. All 3 minors are docstring drift in `Cotangent/GrpObj.lean` introduced by the iter-136 closure:
  1. L506 — `section_snd_eq_identity_struct` referenced as "(below)" but is at L452 (above the consumer at L508).
  2. L596–L597 — `mulRight_globalises_cotangent`'s status line still says "Steps **2 and 3** are the two `def`s above (also `sorry`)" — after iter-136, only Step 2 remains `sorry`.
  3. L427–L432 — section-header comment "Bodies are `sorry` — closure is iter-136+ work" no longer matches post-iter-136 state (Step 3 closed).
  Overall: "iter-136's prover-lane work on `Cotangent/GrpObj.lean` is honest, surgical, and free of excuse-comments — the three minor findings are docstring drift easily corrected in the next plan cycle without blocking downstream work."

- **`lean-vs-blueprint-checker-cotangent-grpobj-review136`** (3.3 min / $1.70 / 13 turns; report: `task_results/lean-vs-blueprint-checker-cotangent-grpobj-review136.md`). One file ↔ one chapter. Verdict: **0 must-fix / 0 major / 2 minor**. Per-declaration: all 7 `\lean{…}`-tagged declarations cross-check cleanly (5 substantively closed + 2 intentional sorry-scaffolds with `\notready` markers). Iter-136 closure of `_restrict_along_identity_section` matches blueprint L527–L528 verbatim ("Applying `PresheafOfModules.pullbackComp` to both sides of the composition identity yields the displayed iso"). Minors:
  1. File-header docstring line-anchor drift continues (L61/L107/L146/L155/L160 cite stale "line 198/244"; actual L210/L256) — pre-known iter-135 MED-C; iter-136 extended drift by ~+12 lines. Deferred.
  2. Optional preventive: one-line `% NOTE` near blueprint L490 distinguishing `schemeHomRingCompatibility` (project-internal, `pullbackPushforwardAdjunction` route) from `(Scheme.Hom.toRingCatSheafHom _).hom` (the `pullback`-functor route used by iter-136 body), to prevent a future prover from re-introducing a parallel helper. Not blocking.

  Blueprint adequacy verdict: **adequate** (5/5 substantive coverage; precise hint precision post iter-135 mathlib-analogist; matches need on sheaf-level framing).

## Blueprint markers updated (manual)

- `RigidityKbar.tex`, `lem:GrpObj_omega_restrict_to_identity_section` (statement block at L515): **stripped `\notready`** — the Lean target is now substantively closed (kernel-only axioms). The iter-135 NOTE block at L505–L514 was also rewritten in-place to reflect iter-136 closure (describing the new `section_snd_eq_identity_struct` helper, the ~27 LOC envelope, and the `change`-based reshape technique) instead of the prior "honest sorry-bodied scaffold; iter-136+ work" framing. The proof block at L524 still carries the iter-134-era `\leanok` from `sync_leanok`, which is now actually correct because the body has been substantively closed; `sync_leanok` re-running post-iter-136 will preserve it.

No other manual marker changes this iter:
- No new `\mathlibok` candidates (iter-136 declaration is project-internal NEEDS_MATHLIB_GAP_FILL-track work, not a Mathlib re-export).
- No `\lean{...}` renames flagged by the prover task result.
- No other `\notready` markers stale (the other two sibling lemmas at L463 and L382 remain correctly `\notready` — Step 2 and Main are still `sorry`-bodied per iter-137+/iter-138+ schedule).

## Notes section

- Per the iter-135 progress-critic's iter-136 next-tier PASS criterion ("iter-136 prover round substantively closes ≥ 1 of the 3 honest-scaffold bodies"): **SATISFIED** (1 of 3 closed substantively, well within ~30–80 LOC envelope; specifically Step 3 at ~27 LOC = helper 5 LOC + body 22 LOC).
- Per `strategy-critic-iter134` CHALLENGE 1 LOC-arm trigger (`> 600 LOC of (i.b)-side build without converging`): iter-136 added ~38 LOC; cumulative iter-134→iter-136 build on the (i.b) family is now ~316 LOC (296 → 612 over 3 iters), comfortably inside the 600-LOC envelope.
- META-PATTERN TRIPWIRE (iter-132 non-promise: no 4th body reshape on `cotangentSpaceAtIdentity`): **HELD** — iter-136 lane did not touch piece-(i.a) declarations; only piece-(i.b) Step 3.
- `current_session/attempts_raw.jsonl` is **fresh** this iter (127 events, all timestamped 2026-05-18T01:16–01:42 matching the iter-136 prover stage start at 2026-05-18T00:50:45Z). No stale-artefact drift recurrence; harness now reliably refreshes the file when the prover runs.
- Prover total cost: $14.75; 1521 s (~25 min); 127 turns; 105k output tokens.
- No new axioms; `archon-protected.yaml` unchanged (9 protected decls).
