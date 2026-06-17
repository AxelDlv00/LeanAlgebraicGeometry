# Blueprint Review Report

## Slug
iter130

## Iteration
130

## Top-level summaries

### Incomplete parts

- `RigidityKbar.tex` / `lem:GrpObj_cotangent_bridge` (lines 122–161): the lemma is authored as a stalk-side cotangent identification (`cotangentSpaceAtIdentity_iso_localRingCotangent` against `Ideal.IsLocalRing.CotangentSpace`). Under the iter-129 `mathlib-analogist-lieAlgebra-rank-bridge-iter129` verdict, the iter-130 prover lane will swap the (i.a) body to Replacement (B) (affine-chart base-change Kähler), not Replacement (A) (stalk-side). Post-iter-130 the bridge's LHS — explicitly described as "the iter-128 evaluate-then-extend-scalars Lean body" at line 141 — no longer denotes the Lean body, and the stalk-side identification is not what (B) directly produces. The bridge becomes incoherent until re-stated. **Severity: must-fix-this-iter** in writer terms; **does NOT block** the iter-130 body-swap prover lane on `cotangentSpaceAtIdentity` itself.
- `RigidityKbar.tex` / `lem:GrpObj_omega_rank_eq_dim` (lines 241–252): prose uses "the relative dimension supplied by `[SmoothOfRelativeDimension n G.hom]`" but the rank-bridge to `cotangentSpaceAtIdentity_finrank_eq` is currently mediated by the bridge lemma above; with that lemma in flux, the rank-at-fibre chain has a missing intermediate target post-iter-130. Recoverable once the bridge is re-stated against (B).

### Proofs lacking detail

- `RigidityKbar.tex` / `lem:GrpObj_cotangentSpace` proof (lines 112–120): the proof says "The iter-128 Lean construction realises $\eta_G^* \Omega_{G/k}$ as the extension of scalars..." and asserts the finitely-generated-free claim follows by combining the bridge with `Ideal.IsLocalRing.CotangentSpace`. The iter-129 analogist proved the iter-128 body collapses to `0` for the consumer class (smooth proper geometrically irreducible `G/k`, `n ≥ 1`); the "realises" verb is therefore factually wrong against the *current* Lean body. The iter-130 prover-lane body swap to Replacement (B) is precisely what restores correctness — the proof prose will need a writer pass once (B) lands to read "the iter-130 Lean construction realises ... as the affine-chart base-changed Kähler module on a chosen chart $V \ni \eta_G$".
- `RigidityKbar.tex` / `lem:GrpObj_cotangent_bridge` proof (lines 144–161): step 2 invokes "$k \otimes_R \Omega_{R/k} \cong \mathfrak m / \mathfrak m^2$" as Stacks Tag 02G1, but the bridge proof goes through `Algebra.Extension.CotangentSpace` infrastructure that requires the local ring $\mathcal O_{G, \eta_G}$ — which under Replacement (B)'s chart-base-change body the Lean side does NOT canonically produce. The proof sketch's chain (`Step 1` localisation + `Step 2` $\mathfrak m/\mathfrak m^2$) is mathematically correct but is the closure path for Replacement (A); under (B) the bridge is a separate ~300–600 LOC build (the (B)→(A) cost).

### Lean difficulty quality

- `RigidityKbar.tex:124` `\lean{AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_iso_localRingCotangent}`: post-iter-130 body swap to Replacement (B), this declaration name binds the prover to constructing a non-trivial bridge from chart-base-change to stalk-side cotangent — not the lightweight identity the prose calls "tautological". Either rename the target to a Replacement-(B)-aligned form (e.g. `cotangentSpaceAtIdentity_finrank_eq_via_chart`, dropping the local-ring-cotangent identification) or accept ~300–600 LOC of bridge work future iters. **Status this iter: soon** — not on iter-130's active prover lane (the lane closes only the body swap).
- `RigidityKbar.tex:165` `\lean{AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_finrank_eq}`: target name is fine and matches the iter-129 analogist's Decision-3 closure path (steps 1–7 in `analogies/lieAlgebra-rank-bridge.md`). Under Replacement (B) this is the 50–100 LOC iter-130+ deliverable. Quality: good.
- `RigidityKbar.tex:203` `\lean{AlgebraicGeometry.GrpObj.mulRight_globalises_cotangent}`, `:230` `\lean{AlgebraicGeometry.GrpObj.omega_free}`, `:243` `\lean{AlgebraicGeometry.GrpObj.omega_rank_eq_dim}`: phantom names whose iter-128+ Lean targets exist as PHANTOMS in the strategy (M2.body-pile piece (i) decomposition). Quality acceptable as forward-reference placeholders; their signature surface is described unambiguously enough in the prose. None of them is on the iter-130 active prover lane.

### Multi-route coverage

Single route (M2 over-k path, committed iter-127). No multi-route coverage analysis needed. The hedged `\mathbb P^1`-specific rigidity sub-route mentioned in STRATEGY.md is documented as a non-active fallback (no blueprint coverage required at this stage).

## Per-chapter

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: true
- **correct**: true
- **notes**:
  - The chapter still describes the genus-0 sub-case in the older "base-change-and-descent" framing in two places (proof of `thm:exists_unique_ofCurve_comp` line 82 mentions "Galois descent of morphism equality back to $k$"; § Implementation route line 87 mentions "rigidity for $\mathbb P^1_{\bar k} \to A_{\bar k}$ together with Galois descent"). Under the iter-127 over-k commitment Galois descent is DROPPED. **Severity: informational** (these are non-load-bearing classical-description paragraphs, not `\lean{...}` hints; recommend a writer pass when convenient).

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: true
- **correct**: true
- **notes**:
  - All declaration blocks carry `\leanok` markers; the chapter ships as Mayer–Vietoris + Čech infrastructure for Phase A. The two carrier classes `HasCechToHModuleIso` and `HasAffineCechAcyclicCover` are honestly documented as unproduced (§ "Producer status", line 947). Project ships conditionally on these carriers, parallel to `nonempty_jacobianWitness` — this is intentional and self-disclosing.

### blueprint/src/chapters/Cohomology_SheafCompose.tex
- **complete**: true
- **correct**: true
- **notes**: -

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: true
- **correct**: true
- **notes**: -

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: true
- **correct**: true
- **notes**: -

### blueprint/src/chapters/Differentials.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Post-iter-126 M1 excise the chapter cleanly hosts (a) the relative differentials presheaf + its `obj_kaehler` `rfl` lemma, (b) `smooth_locally_free_omega` forward direction, (c) the standalone Kähler-localisation utilities `kaehler_localization_subsingleton` + `kaehler_quotient_localization_iso`. § "Converse direction" (M4) is correctly documented as scheduled-not-done. No drift.

### blueprint/src/chapters/Genus.tex
- **complete**: true
- **correct**: true
- **notes**:
  - The `noncomputable` user-authorisation paragraph (§ "User authorisation of `noncomputable`") is in place and explains the deviation from the protected challenge file's literal signature.

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - **Stale line refs** (per iter-129 lean-vs-blueprint-checker carry-over): line 398 cites `AlgebraicJacobian/Jacobian.lean:120--126` for `geometricallyIrreducible_id_Spec` — actual location is lines 134–140; line 410 cites `AlgebraicJacobian/Jacobian.lean:174--178` for `genusZeroWitness` body — actual location is lines 188–192. Editorial (no `\lean{...}` hint impact); **severity: informational**.
  - **Genus-0 sub-case prose (lines 313–365) has been correctly migrated** to the over-k commitment: C.2.f is explicitly marked DROPPED (line 352–353), C.2.g (lines 354–355) cleanly enumerates the over-k pile pieces (i)+(ii)+(iii), and the Mathlib-infrastructure-summary ($\alpha$/$\beta$/$\gamma$) at lines 367–373 names $\gamma$ as the over-k rigidity-over-`k̄` route. The integration is clean.
  - The `\proof` of `thm:nonempty_jacobianWitness` does `\uses{thm:GrpObj_eq_of_eqOnOpen, def:genusZeroWitness, thm:rigidity_over_kbar}` (line 248) — all three targets are live (`Scheme.Over.ext_of_eqOnOpen`, `genusZeroWitness`, `rigidity_over_kbar`). Cross-refs clean.

### blueprint/src/chapters/Rigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Post-iter-125 refactor `Scheme.Over.ext_of_eqOnOpen` is cleanly documented (statement + Mathlib ingredients + project consumers). Cross-refs to `chap:RigidityKbar` are in place (§ "Use in the project" lines 57). § "Mathlib status" (line 63) honestly notes the upstream-PR candidate but flags it as not pursued.

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - **(i.a) statement+proof** (`lem:GrpObj_cotangentSpace`, lines 92–120) describe the *iter-128 body* (evaluate-then-extend-scalars at `op ⊤`) as the canonical realisation of $\eta_G^* \Omega_{G/k}$ ("The iter-128 Lean construction realises..." line 115). This is **factually wrong** per the iter-129 mathlib-analogist verdict: the iter-128 body collapses to zero for every $G$ in the consumer class with relative dimension $\ge 1$. The mathematical statement of the lemma — "finitely generated free $k$-module" — is what Replacement (B) will deliver post-iter-130 body swap; the prose error is the description of *which* Lean body realises the math.
  - **(i.a-bridge) `lem:GrpObj_cotangent_bridge`** (lines 122–161): statement (line 141) explicitly names the LHS "the iter-128 evaluate-then-extend-scalars Lean body"; proof calls this "tautological" (line 160). Under iter-130's Replacement (B) body swap neither the LHS framing nor the tautologicality holds — the bridge to `Ideal.IsLocalRing.CotangentSpace` becomes a ~300–600 LOC (B)→(A) build, not a tautological identification. The `\lean{...}` hint at line 124 (`cotangentSpaceAtIdentity_iso_localRingCotangent`) binds the prover to constructing this bridge.
  - **(i.b)/(i.c) lemma trio** (`lem:GrpObj_mulRight_globalises`, `lem:GrpObj_omega_free`, `lem:GrpObj_omega_rank_eq_dim`): statements and proof sketches are mathematically clean and intrinsic to $G$ (shear iso functoriality + global-frame conclusion); they do NOT consume the iter-128 body shape and so are not affected by the iter-130 body swap. Quality: good. All carry `\notready` markers.
  - **§ "Iter-127 over-k commitment"** (paragraph at line 14) is correctly placed and unambiguously commits the chapter to the over-k path. The variable name `kbar` is acknowledged as a legacy artefact and the rename to `k` is deferred — this is a known editorial item, not a correctness issue.
  - **`\lean{AlgebraicGeometry.rigidity_over_kbar}`** (line 20): declaration exists in the Lean tree (`AlgebraicJacobian/RigidityKbar.lean:75`, body `sorry`). The variable-name drift `kbar` (Lean) vs. the chapter's stated over-k semantics (LaTeX) is documented but suboptimal; **severity: informational**.

## Cross-chapter notes

- **`Jacobian.tex` C.2.f → C.2.g**: C.2.f is correctly marked DROPPED iter-127; C.2.g cleanly inventories the over-k shared pile pieces. The `\thm{thm:rigidity_over_kbar}` cross-ref to `chap:RigidityKbar` is live. `AbelJacobi.tex` still mentions "Galois descent" in two non-`\lean{...}` paragraphs (proof of `thm:exists_unique_ofCurve_comp` line 82; § Implementation route line 87) — these are stale but informational (not load-bearing).
- **`RigidityKbar.tex` ↔ `analogies/lieAlgebra-rank-bridge.md`**: the iter-129 analogist's Recommendation (Replacement B) and the iter-130 PROGRESS.md directive (body swap to (B)) are **not yet absorbed into the chapter prose**. The chapter currently authors the bridge lemma against Replacement (A) framing (stalk-side cotangent). This is the central drift this iter; the prose-vs-Lean discrepancy must be re-aligned in iter-131+ once (B) lands.
- **Phantom declaration names**: all five `\lean{...}` hints under `RigidityKbar.tex` § "Piece (i) sub-lemma decomposition" (`cotangentSpaceAtIdentity_iso_localRingCotangent`, `cotangentSpaceAtIdentity_finrank_eq`, `mulRight_globalises_cotangent`, `omega_free`, `omega_rank_eq_dim`) are phantom under Mathlib `b80f227` and the Lean tree (only `cotangentSpaceAtIdentity` is landed). Names are STRATEGY-mapped to iter-130+ build targets and align with `analogies/lieAlgebra-rank-bridge.md` closure path (steps 1–7). Quality acceptable as forward references; `cotangentSpaceAtIdentity_iso_localRingCotangent` is the only one with semantic risk under (B) (see "Lean difficulty quality").

## Strategy-modifying findings

None. The iter-127 over-k commitment + iter-129 Replacement-(B) verdict are consistent and absorbed at the strategy level. The blueprint-side drift is **chapter-prose-vs-Lean-body**, not strategy-vs-Lean.

## Severity summary

- **must-fix-this-iter**:
  - `RigidityKbar.tex` carries `complete: partial` + `correct: partial` per the per-chapter checklist. Under the dispatcher_notes HARD GATE rule verbatim, this triggers a writer dispatch for `RigidityKbar.tex` **THIS iter, in parallel with the prover dispatch**. The writer directive should target two items:
    1. Re-state `lem:GrpObj_cotangent_bridge` so its LHS is the *chart-base-changed Kähler* form delivered by Replacement (B), not "the iter-128 evaluate-then-extend-scalars Lean body". The `\lean{...}` hint target name (`cotangentSpaceAtIdentity_iso_localRingCotangent`) should be re-pointed (e.g. drop it from this iter and re-introduce in a future iter when the bridge becomes load-bearing, or rename to a Replacement-(B)-aligned shape).
    2. Rewrite the proof of `lem:GrpObj_cotangentSpace` (lines 112–120) so it does not claim "the iter-128 Lean construction realises $\eta_G^* \Omega_{G/k}$" — replace with the chart-base-change construction that (B) actually delivers. Keep the mathematical statement (finitely-generated-free) unchanged; only the *which Lean body realises it* sentence needs to be re-aligned.
- **soon**:
  - `Jacobian.tex` lines 398 + 410 stale line refs (cosmetic).
  - `AbelJacobi.tex` § "Galois descent" residual mentions (lines 82 + 87) — non-load-bearing.
  - `RigidityKbar.tex` variable-name `kbar` → `k` rename + chapter title cleanup (scheduled iter-129+ low-priority).
- **informational**:
  - Phantom forward-reference names in `RigidityKbar.tex` § "Piece (i)" subsection — acceptable as scaffolds; alignment work scheduled in their respective iter-130+ build slots.

### HARD GATE per-file verdict

Per the directive's instruction to apply the gate verbatim:

- **`AlgebraicJacobian/Cotangent/GrpObj.lean`** → `RigidityKbar.tex` is `complete: partial` + `correct: partial`. **Rule application**: under the strict reading, the prover lane on `Cotangent/GrpObj.lean` should be DROPPED and a blueprint-writer dispatched.
- **HOWEVER**, the directive itself explicitly asks (question 1) whether the chapter-prose-vs-Lean-body drift blocks the iter-130 body swap, or whether it is tolerable (since iter-130's prover lane is precisely what will land the body that the chapter prose currently lies about). **My recommendation**: GREEN-LIGHT the iter-130 prover lane on the body swap, in parallel with a same-iter blueprint-writer dispatch to re-align `RigidityKbar.tex` § "Piece (i)" to Replacement (B).

**Rationale for the green-light**:
1. The iter-130 prover lane's deliverable is *unambiguously specified* by `analogies/lieAlgebra-rank-bridge.md` Recommendation (Replacement B, body sketch at lines 128–145) + PROGRESS.md directive. The prover does not need the chapter prose to be aligned — the directive itself overrides the chapter's framing for this iter.
2. The mathematical statement of `lem:GrpObj_cotangentSpace` ("finitely generated free $k$-module of cotangent at identity") is what (B) will deliver. Only the description of *which* Lean body realises that math is wrong in the current prose; the wrongness is downstream-fixable.
3. Dropping the iter-130 prover lane and dispatching writer-only would *waste* the iter — the writer can dispatch in parallel and finalise on iter-131 once the new body is in the tree.

**Suggested directive for the parallel blueprint-writer on `RigidityKbar.tex` this iter**:
> Re-align `RigidityKbar.tex` § "Piece (i)" to Replacement (B) per `analogies/lieAlgebra-rank-bridge.md`. Two specific items: (a) rewrite the proof of `lem:GrpObj_cotangentSpace` (lines 112–120) to describe Replacement (B)'s chart-base-change construction; (b) re-state `lem:GrpObj_cotangent_bridge` (lines 122–161) — either drop the `\lean{...}` hint for `cotangentSpaceAtIdentity_iso_localRingCotangent` (defer the bridge to a future iter with a `% NOTE`) or rename it to a (B)-aligned target. Do NOT touch the (i.b)/(i.c) trio (already (B)-compatible) and do NOT touch `lem:GrpObj_lieAlgebra_finrank` statement (the rank-equals-`n` claim is the (B) closure target and is mathematically correct).

**For `Jacobian.lean:192` `genusZeroWitness` (iter-127 scaffold)**: chapter `Jacobian.tex` covers `def:genusZeroWitness` with `complete: true`, `correct: partial` (only stale line refs); the genus-0 arm prose is over-k-aligned. **GREEN LIGHT for any future iter-138+ body closure**; not active this iter, per directive.

**For `RigidityKbar.lean:87` `rigidity_over_kbar` (iter-126 scaffold)**: OFF-LIMITS this iter per directive; gate not applicable.

Overall verdict: **`RigidityKbar.tex` carries must-fix-this-iter drift around its (i.a) prose framing, but does NOT block the iter-130 prover-lane body swap; recommend GREEN-LIGHT for `Cotangent/GrpObj.lean` prover dispatch with a parallel blueprint-writer dispatch to re-align Piece (i) to Replacement (B).**
