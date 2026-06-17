# Session 52 (iter-052) — review summary

## Metadata
- **Iteration:** 052 — **Session:** session_52 — model: claude-opus-4-8 (provers)
- **Sorry count:** 2 → 2 (no change). Both pre-existing & frozen: `CechAcyclic.lean:110` dead
  `affine`; `CechHigherDirectImage.lean:780` protected P5b `cech_computes_higherDirectImage`.
  All new declarations this iter are 0-sorry.
- **Build:** GREEN. Review re-verified first-hand (`lean_verify`) both Lane-A headline theorems =
  `{propext, Classical.choice, Quot.sound}`; prover ran full `lake env lean AffineSerreVanishing.lean`
  (EXIT 0) and `lake build …CechHigherDirectImage` (EXIT 0).
- **Targets attempted:** Lane A (`AffineSerreVanishing.lean`, discharge the two 02KG tops) — **SOLVED**.
  Lane B (`CechHigherDirectImage.lean`, `cechAugmented_exact`) — **PARTIAL/BLOCKED** (file placement).
- **Net:** +6 axiom-clean declarations (3 Lane A, 3 Lane B), 0 new sorries.

## Lane A — `AffineSerreVanishing.lean` (SOLVED) — both 02KG tops now UNCONDITIONAL

The single crisp residual (iter-049/050/051 arc) is fully discharged. The prover added a private
reshaping helper and two one-line specializations:

- **`affine_tildeVanishing`** (private, ~line 496) — bundles iter-051's
  `sectionCech_homology_exact_of_localizationAway (moduleSpecΓFunctor.obj F) (fun i => g i.down) f hcov p hp`
  into the exact `ULift (Fin n)`-indexed `htilde` shape the two reduction lemmas consume.
  - `cechCohomology U (toPsh.obj (tilde M)) p` is **defeq** `(sectionCechComplex U (tilde M)).homology p`
    (def of `cechCohomology`) — no coercion.
  - `hp : 0 < p` feeds directly as `1 ≤ p` (defeq in ℕ) — no `omega`.
  - Deliberately carries **no** `[F.IsQuasicoherent]` (it is about `~Γ(F)`, not `F`; the qcoh hyp lives
    in the outer tops — lean-auditor confirmed this is correct, not a missing constraint).
- **`affine_cech_vanishing_qcoh`** (~line 516) = `affine_cech_vanishing_qcoh_of_tildeVanishing F (affine_tildeVanishing F)`.
  Signature `(F : (Spec R).Modules) [F.IsQuasicoherent] : HasVanishingHigherCech (affineCoverSystem R) F`.
- **`affine_serre_vanishing`** (~line 521) = `affine_serre_vanishing_of_tildeVanishing F (affine_tildeVanishing F) p hp e`.
  Signature `[EnoughInjectives (Spec R).Modules] (F) [F.IsQuasicoherent] (p) (hp : 0 < p) (e : Ext (jShriekOU ⊤) F p) : e = 0`.
  Matches the `\lean{}` pin.

All three `lean_verify` = `{propext, Classical.choice, Quot.sound}` (line-30 `local instance`
warning = intentional `hasExtModules` reactivation, not a soundness flag).

## Lane B — `CechHigherDirectImage.lean` (PARTIAL) — honest file-placement blocker

The prover adopted the planner's D1 sections/sheafification route, then discovered `cechAugmented_exact`
**cannot be proved in this file**: every route ingredient lives downstream.

| Ingredient | Lives in | Imports CechHigherDirectImage? |
|---|---|---|
| `PresheafOfModules.homologyIsoSheafify` | `HigherDirectImagePresheaf.lean` | YES (direct) |
| `sectionCech_affine_vanishing`, `…_of_localizationAway` | `CechAcyclic.lean` | YES (direct) |
| `sectionCechComplex` | `PresheafCech.lean` | YES (direct) |
| `affineCoverSystem`, `standard_cover_cofinal` | `AffineSerreVanishing.lean` | YES (transitive) |
| `qcoh_iso_tilde_sections` | `QcohTildeSections.lean` | YES (transitive) |

`CechHigherDirectImage.lean` imports only `HigherDirectImage` (+Mathlib) — it is the most-upstream
Cohomology file. Using any ingredient back is an import cycle. **This is a routing decision, not a
math gap or a "try harder" case.** No sorry inserted; no hypothesis-weakened stand-in under the pinned
name; `cechAugmented_exact` left absent per the no-sorry invariant.

### What the prover built instead (genuinely upstream-buildable Step-2 core)
Three pure-Mathlib site-theory lemmas (sheafification annihilates a locally-zero presheaf homology),
correctly placed upstream so the relocated theorem can import them — all axiom-clean:
- `CategoryTheory.GrothendieckTopology.isZero_presheafToSheaf_obj_of_W` (~810) — `W_iff` ⇒ iso ⇒ `IsZero.of_iso`.
- `…isZero_presheafToSheaf_obj_of_W_isZero` (~826) — `presheafToSheaf_additive` + `Functor.map_isZero`.
- `…isZero_presheafToSheaf_obj_of_isLocallyBijective` (~843) — `W_of_isLocallyBijective` + the above.

### Attempts (from attempts_raw.jsonl)
- Scratch `example` at EOF probing `homologyIsoSheafify (𝟙 X.ringCatSheaf.obj) … (cechAugmentedComplex 𝒰 F) i`
  to confirm the bridge — then an import-dependency audit (`grep` of imports across the 5 files) confirmed
  the cycle; scratch reverted.
- Search probes (`lean_leansearch`/`lean_loogle`) for `W` / `WEqualsLocallyBijective` /
  `IsLocallyInjective` / `presheafToSheaf_additive` to assemble the three lemmas.
- The remaining bridge (NOT attempted, deliberately): reflect module-sheafification `IsZero` through the
  faithful additive `SheafOfModules.toSheaf`, matching `toSheaf ∘ sheafification` with `presheafToSheaf ∘ forget`
  (the `sheafificationCompToSheaf` square). Left for the relocated file — it would be unconsumed dead code here.

## Key findings / patterns
- **The 02KG-tops discharge is purely mechanical once the residual exists** — a private reshaper +
  two one-line specializations. (KB Proof Pattern added.)
- **When a route's math heart is downstream but a sub-step is pure Mathlib site theory, land the
  sub-step upstream** so the relocated main theorem can import it. (KB Proof Pattern + Known Blocker added.)
- The iter-051 "missing stalkwise-criterion" framing of the `cechAugmented_exact` blocker is now
  **superseded**: the chosen sections route avoids stalkwise entirely; the real wall is file placement.

## Review subagents (reports under task_results/, archived to logs/iter-052/)
- **lean-auditor `iter052`**: 0 critical / 0 major / 7 minor (all pre-existing style lints; new decls
  non-vacuous, `of_W` iso-direction correct, no kernel-soundness trap, frozen sorry comments accurate).
- **lvb `asv`** (AffineSerreVanishing): SOUND, 0 must-fix; 14 decls faithful; flagged 2 stale `% NOTE`s
  (now removed by review) + 2 minor (private helper unblueprinted; `toSheaf_preservesFiniteColimits`
  per-diagram vs abstract sketch — equivalent).
- **lvb `chdi`** (CechHigherDirectImage): 1 must-fix (the relocation) + 2 major blueprint-adequacy
  (3 site lemmas need `\lean{}` blocks; proof sketch silently assumes co-location).

## Blueprint markers updated (manual)
- `Cohomology_CechHigherDirectImage.tex`, `lem:affine_serre_vanishing`: refreshed stale iter-049
  `% NOTE` (target is now a closed axiom-clean decl; flagged trailing prose paragraph as stale for a writer).
- `Cohomology_CechHigherDirectImage.tex`, `lem:affine_cech_vanishing_qcoh`: refreshed stale `% NOTE`
  (unconditional form now closed).
- `Cohomology_CechHigherDirectImage.tex`, `lem:cech_augmented_resolution`: updated `% NOTE` with the
  iter-052 import-cycle / relocation finding + the upstream Step-2 site lemmas now available.
- No `\leanok` / `\mathlibok` / `\notready` touched. (sync_leanok iter=52, sha 8ce6ddb, +13/−0,
  chapter `Cohomology_CechHigherDirectImage.tex`.)

## Blueprint doctor
No structural findings (every chapter `\input`'d, every `\ref`/`\uses` resolves, no `axiom` decls).

## Coverage debt (`archon dag-query unmatched` = 5)
Listed for the planner in `recommendations.md`: 4 new this iter (`affine_tildeVanishing` private +
3 site lemmas) + the pre-existing dead `CechAcyclic.affine`.
