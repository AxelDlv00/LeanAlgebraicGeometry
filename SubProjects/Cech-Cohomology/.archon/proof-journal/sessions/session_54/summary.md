# Session 54 (iter-054) — review summary

## Metadata
- **Session / iter:** session_54 = iter-054. Model: claude-opus-4-8.
- **Inline sorry:** 5 → 5 (no regression, no new sorry). Breakdown unchanged in count:
  - `CechAugmentedResolution.lean:205` — residual `Homotopy (𝟙 D) 0` (SHARPENED this iter from `IsZero …homology p`).
  - `OpenImmersionPushforward.lean:224` — `_acyclic` Serre-vanishing leaf (deep clean reduction this iter).
  - `OpenImmersionPushforward.lean:290` — `_comp` body (re-signed `≅` this iter; depends on `_acyclic`).
  - `CechHigherDirectImage.lean:780` — frozen protected P5b `cech_computes_higherDirectImage`.
  - `CechAcyclic.lean:110` — dead `affine` stub (superseded; flagged for deletion).
- **Build:** GREEN. Prover ran `lake env lean` on both touched files (exit 0, only `uses sorry` warnings).
- **Lanes planned 2, ran 2.** Both PARTIAL-with-progress. **+5 axiom-clean decls** (1 + 4), 0 new sorries.

## Targets

### Lane 1 — `cechAugmented_exact` (CechAugmentedResolution.lean) — PARTIAL
Built `isZero_homology_of_homotopy_id_zero` (the Step-3(d) brick: `Homotopy (𝟙 D) 0 → IsZero (D.homology p)`,
any preadditive `C`), verified axiom-clean (`{propext, Classical.choice, Quot.sound}` — re-confirmed
first-hand by review via `lean_verify`). Proof is the 3-lemma combo from `analogies/deepbridge.md`:
```
refine (IsZero.iff_id_eq_zero _).mpr ?_
rw [← HomologicalComplex.homologyMap_id, ho.homologyMap_eq p, HomologicalComplex.homologyMap_zero]
```
Wired into `cechAugmented_exact`'s `hSec` residual, sharpening the single sorry from
`IsZero (((GV.mapHomologicalComplex cc).obj Kp).homology p)` to the precise contracting-homotopy
obligation `Homotopy (𝟙 ((GV.mapHomologicalComplex cc).obj Kp)) 0` (line 205).

**Decisive finding (D1 reversal signal triggered):** the residual is **Sub-brick A** — the per-degree
section identification `Γ(V, pushPullObj F Y) ≅ ∏_σ Γ(U_σ∩V, F)` (degreewise + differential) — which is the
**SAME L1 categorical bridge that keeps `CechAcyclic.affine` open** (CechAcyclic.lean:106-109). The two
lanes share ONE irreducible obstruction. The pushforward half is now confirmed DEFINITIONAL
(`Scheme.Modules.pushforward_obj_obj`); the remaining gaps are pullback-along-open-immersion sections +
backbone geometry of `coverCechNerveOver` + differential match. Sub-brick B (concrete contractibility via
prepend-`i_fix`, given A) is **independently blocked** because the `CombinatorialCech.Dependent` engine
(`depDiff`/`depHomotopy`/`depDiff_exact`) is `private` to `CechAcyclic.lean` — unusable from this file.
Alternatives ruled out: ExtraDegeneracy (variance), abstract homotopy on `D` (no exposed product
structure), geometric extra-degeneracy (scheme-level, harder). Informal-agent unavailable (no API key).

### Lane 2 — `higherDirectImage_openImmersion_acyclic` / `_comp` (OpenImmersionPushforward.lean) — PARTIAL
Added 4 axiom-clean decls:
- `CategoryTheory.Functor.isZero_of_faithful_preservesZeroMorphisms` — copy of the CechAugmentedResolution
  helper (sibling file not in import chain).
- `CategoryTheory.GrothendieckTopology.isZero_presheafToSheaf_of_sections_locally_zero` — **new** sectionwise
  (local-injectivity) strengthening; needed because the affine opens are NOT downward-closed so the
  objectwise-zero form doesn't apply. Re-confirmed axiom-clean first-hand by review (`lean_verify`).
- `pushforwardSectionsFunctor` (def) + `pushforwardSectionsFunctor_additive` (instance) — sections-over-`j⁻¹W`
  functor `M ↦ Γ(W, j_* M) = Γ(j⁻¹W, M)`. **Additivity trap:** the flat 5-fold composite with `pushforward j`
  outermost defeats `infer_instance` even at top level with `synthInstance.maxHeartbeats 1000000`; built via
  explicit `instAdditiveComp` chain passing the tail instance EXPLICITLY (`@…instAdditiveComp … hpf … i2`).

`_acyclic` reduction wired axiom-clean (toSheaf-reflect → `sheafificationCompToSheaf` → sectionwise site
lemma → affine-basis sieve → restriction factoring) down to the single, precisely-typed residual (line 224):
`IsZero (((pushforwardSectionsFunctor j W).rightDerived q).obj H)` for affine `W`, `q>0` — i.e. Serre
vanishing `Hᵠ(j⁻¹W, H)=0`. The `hcomplex` identification is a definitional `rfl`; `isoRightDerivedObj`
recognises the homology as `(rightDerived q).obj H`.

`_comp` re-signed `Nonempty (A ≅ B)` → canonical `A ≅ B` (`noncomputable def`) per planner D2 — now matches
the blueprint. Body still `sorry` (line 290); all inputs depend on the `_acyclic` residual (and its `f_*`
generalisation).

## Soundness
- Review re-verified first-hand: `lean_verify` on `isZero_homology_of_homotopy_id_zero` and
  `isZero_presheafToSheaf_of_sections_locally_zero` = `{propext, Classical.choice, Quot.sound}`.
- Prover ran full `lake env lean` (exit 0) on both files — the real kernel check that catches the
  subsingleton-coherence trap (`congr 1`/`Subsingleton.elim` at OpenImmersionPushforward 247/249 are the trap
  zone; exit 0 confirms kernel-soundness).
- No forced mathematics, no papering: both lanes stopped at honest residuals; no new sorry inserted.

## Subagent findings (all 3 highly-recommended review subagents dispatched)
- **lean-auditor `iter054`** (`task_results/lean-auditor-iter054.md`): **0 must-fix, 1 major, 3 minor.**
  All 3 sorries confirmed honest holes with verified goal states; NO subsingleton-coherence kernel trap —
  the `congr 1` (OpenImmersion:247, on `op a = op b` in a thin preorder → proof irrelevance) and
  `Subsingleton.elim` (249, from a genuine zero object) are kernel-sound; the explicit `instAdditiveComp`
  chain masks no wrong instance. Major = duplicate `isZero_of_faithful_preservesZeroMorphisms` across two
  files. Minor = unused `hF` in `cechAugmented_exact` + 2 inline planner-strategy blocks.
- **lvb `cechaug`** (`task_results/lean-vs-blueprint-checker-cechaug.md`): `cechAugmented_exact` signature +
  residual + `isZero_homology_of_homotopy_id_zero` all CONFIRMED faithful to the blueprint Step 3(b)–(d).
  2 major (both blueprint-side): missing `\lean{}` for `isZero_homology_of_homotopy_id_zero`; blueprint
  underspecifies the Step-3(b)+(c) `Homotopy` construction. 0 must-fix.
- **lvb `openimm`** (`task_results/lean-vs-blueprint-checker-openimm.md`): both signatures match (incl. the D2
  `≅` re-sign); `_acyclic` reduction wired to the correct leaf. 3 major (all blueprint-side): **Bridge (3)
  proof sketch MISDIRECTS** (points to objectwise `of_locally_isZero`; the proof needed the sectionwise
  `of_sections_locally_zero` because affine opens are not downward-closed) — a genuine blueprint-correctness
  gap; missing `\lean{}` for the sectionwise lemma + the duplicate helper. 0 must-fix. **NOTE:** its
  "broken `private` pin for `isAffineHom_of_affine_separated`" major was checked first-hand and is NOT
  confirmed — `lean_verify` resolves the qualified name and `dag-query unmatched` matched it.

All findings folded into `recommendations.md`.

## Blueprint markers updated (manual)
- None this iter. (No new Mathlib re-export aliases ⇒ no `\mathlibok`; no renames flagged ⇒ no `\lean{}`
  corrections; no stale `\notready`. The 5 new `lean_aux` decls need blueprint PROSE blocks, which is the
  planner's domain — listed in `recommendations.md`.)

## Blueprint doctor
No structural findings (all chapters `\input`'d, all `\ref`/`\uses` resolve, no `axiom` decls).
`sync_leanok` ran iter-054 (sha `e570e7a`, +4/−0, chapter `Cohomology_CechHigherDirectImage.tex`).
