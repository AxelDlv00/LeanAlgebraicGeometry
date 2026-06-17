# Lean Audit Report

## Slug
iter056

## Iteration
057 (auditing iter-056 prover output)

## Scope
- files audited: 3 (per directive — narrow-scope dispatch)
- files skipped (per directive): all other .lean files — directive explicitly restricted to three prover-touched files

---

## Per-file checklist

### AlgebraicJacobian/Picard/FlatteningStratification.lean

- **outdated comments**: 2 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **L3153** — STATUS comment header says `"STATUS (iter-055)."` but two of the eight bullet points it introduces are explicitly tagged `"(iter-056)"` (`gf_isEpi_restrict_of_affine_le` and `gf_flat_of_isEpi`). The header predates the iter-056 additions and was not updated when those were appended. Minor staleness — the header should read `"STATUS (iter-056)."` to match the most recent entry in the list.
  - **L3109–3133** — Long in-body comment (`SIGNATURE CORRECTNESS FIX (iter-023)`) ends with `"it is reported in task_results + TO_USER for the planner/mathematician to ratify."` That ratification obligation was an action item from iter-023; it is now 30+ iterations stale. The signature fix itself is sound and baked into the code, but the final clause reads as an open action item that has long since closed. Minor.
  - **L3014–3017** — `gf_flat_of_isBaseChange_id`: one-line wrapper, axiom-clean, correctly abstracts the base-change identity. Not in directive focus but coherent.
  - **L3026–3031** — `gf_flat_of_isEpi`: axiom-clean. Uses `IsBaseChange.of_equiv (TensorProduct.lid' A R M)` + `Module.Flat.isBaseChange`. The docstring (L3019–3025) correctly describes the route — ring epimorphism ⟹ `R ⊗[A] M ≅ M` via `lid'` ⟹ base change ⟹ flat. Consistent with code.
  - **L3041–3061** — `gf_isEpi_restrict_of_affine_le`: axiom-clean. Route (affine open immersion ⟹ `Spec.map ρ` mono via `hV.map_fromSpec` + `mono_of_mono`; reflect through `Spec.fullyFaithful`; `unop_epi_of_mono`) is mathematically sound for the affine case and the docstring (L3033–3040) accurately describes it.
  - **L3063–3083** — `genericFlatness` docstring accurately reports current state: epi-descent discharged by `gf_isEpi_restrict_of_affine_le` + `gf_flat_of_isEpi`, one sorry remains at per-piece flatness over `Γ(S,V) = A_f`. Not stale.
  - **L3268–3285** — `flatV` sorry block: the surrounding comment (L3268–3284) claims `"NO Mathlib gap remains"` and `"NO missing infrastructure"` and enumerates four sub-steps all referencing lemmas that ARE present earlier in the same file (`Module.free_of_isLocalizedModule`, `gf_flat_localizedModule_sameBase`, `Scheme.Modules.isLocalizedModule_basicOpen`). The sorry is HONEST — it describes a concrete route of in-file lemma threading, not a mathematical gap. Not an excuse-comment.
  - **L3287** — `exact gf_flat_of_isEpi (A := Γ(S, S.basicOpen f)) (R := Γ(S, U)) (M := Γ(F, X.basicOpen g))` — the base-change descent call IS substantive and uses the new helper, consistent with "DISCHARGED" claims in the docstring.

---

### AlgebraicJacobian/Picard/GrassmannianQuot.lean

- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **L162–173** — STALE SCAFFOLD NOTE. The comment reads:
    ```
    NOTE (scaffold): the body and the module-cocycle hypotheses on `g` are still to be
    filled; the transition data `g` (per-overlap pullback isos) is recorded in the
    signature, the multiplicative cocycle conditions remain to be added before the
    construction is closed.
    ```
    This described the state BEFORE the `glue` body was implemented. The actual `Scheme.Modules.glue` definition at L245–307 IS fully implemented as an equalizer of pushforwards (`equalizer a b` of two maps into `∏ᶜ Qfun`, using `pushforward`, `pullbackPushforwardAdjunction`, `pushforwardComp`). The NOTE now actively misleads: it says the body is "still to be filled" when it is complete. Must remove or replace with a note that the construction is closed.
  - **L245–307** — `Scheme.Modules.glue`: SUBSTANTIVE equalizer construction. Uses `equalizer`, `Pi.lift`, `pushforward`, `pullbackPushforwardAdjunction`, `pushforwardComp`. Not an `Iso.refl` or laundered proof. Axiom-clean.
  - **L392** — `universalQuotient`: `sorry` with honest NOTE: `"glue has landed, remaining obligation is GL_d bundle transition cocycle (net-new)"`. This accurately names the new mathematical gap (not blocked on glue). Honest.
  - **L402** — `tautologicalQuotient`: `sorry` with honest NOTE: `"rides on universalQuotient"`. Accurate dependency chain.
  - **L817** — `functor`: axiom-clean including `map_id` and `map_comp` via `pullbackFreeIso_id`/`pullbackFreeIso_comp`. Not sorry-hidden.
  - **L896** — `represents`: `sorry` with honest NOTE: `"functor and glue have landed; rides on tautologicalQuotient"`. Accurate.
  - **L502–802** — `pullbackObjUnitToUnit_id`, `pullbackFreeIso_id`, `homEquiv_conjugateEquiv_app`, `pullbackObjUnitToUnit_comp`, `pullbackFreeIso_comp`: all axiom-clean term-mode proofs; inline comments explaining `rw`/diamond failures are accurate and useful.

---

### AlgebraicJacobian/Picard/SectionGradedRing.lean

- **outdated comments**: 1 flagged (low-severity labeling confusion)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **L476–502** — `relTensorTriplePresheaf`: NEW this iter. Axiom-clean functor `U ↦ Γ(U,P) ⊗_ℤ (𝒪_X(U) ⊗_ℤ Γ(U,Q))`. Substantive — not a trivial alias or laundered definition. Consistent with the description in the deferred-handoff comment that follows.
  - **L504–558** — Primary deferred-handoff block for `relTensorActL`: states root cause as carrier gap `↥(P.obj U)` vs `↥((P.presheaf).obj U)`. Honest about the blocker. Proposes 3 next-iter handles. Not an excuse-comment (it is a genuine forward-work description, not an admission that something wrong has been accepted).
  - **L559–641** — SUPERSEDED handoff block: labeled `"### (superseded handoff notes — retained for the additional inferInstanceAs detail)"`. The body says `"NOT a carrier mismatch"` — directly contradicting the primary block's root-cause attribution. The `(superseded)` label disambiguates priority, but a reader must parse the label to know which block wins. Minor clarity issue: the primary block (L504–558) is the authoritative analysis; the superseded block should ideally be pruned to just the `inferInstanceAs` detail it claims to retain, not left in full with a contradictory root-cause claim.
  - **L643–758** — `tensorPowAdd` deferred section: honest and detailed. Lists routes (a/b/c), all blocked, with iter-052/053 progress and next-iter task. Not an excuse-comment.
  - **L1–475** — `RelativeTensorCoequalizer` namespace and earlier content: all axiom-clean. `isColimitCofork` is substantive (`TensorProduct.liftAddHom` + `cancel_epi`). No issues.

---

## Must-fix-this-iter

- `AlgebraicJacobian/Picard/GrassmannianQuot.lean:162–173` — Stale scaffold NOTE says `glue` body "is still to be filled" and "cocycle conditions remain to be added". The `glue` definition at L245–307 IS fully implemented as an equalizer of pushforwards. The NOTE actively misleads anyone reading the file about the state of the construction. Must remove or replace with an accurate description. **Why must-fix**: the NOTE is an incorrect description of a load-bearing definition (`Scheme.Modules.glue`) that has been closed; leaving it causes reviewers (and future provers touching the 3 remaining sorries that depend on `glue`) to have a false picture of what has and hasn't been proved.

---

## Major

- `AlgebraicJacobian/Picard/SectionGradedRing.lean:559–641` — Superseded handoff block contradicts the primary block's root-cause attribution for `relTensorActL` (primary: "carrier gap"; superseded: "NOT a carrier mismatch"). The `(superseded)` label prevents this from being must-fix, but leaving a full contradictory analysis in place creates a false picture of the open problem. Should be pruned to only the `inferInstanceAs` detail the label claims to retain.

---

## Minor

- `AlgebraicJacobian/Picard/FlatteningStratification.lean:3153` — STATUS comment header says `"iter-055"` but two of the DONE items in the same list are tagged `"(iter-056)"`. Header should be updated to `"iter-056"`.
- `AlgebraicJacobian/Picard/FlatteningStratification.lean:3132–3133` — End of `SIGNATURE CORRECTNESS FIX (iter-023)` comment says `"it is reported in task_results + TO_USER for the planner/mathematician to ratify"` — this ratification request is 30+ iterations old. The sentence is now dead historical text; delete it.

---

## Excuse-comments (always called out separately)

None. No excuse-comments found in any of the three audited files. The sorries present (`flatV` in FlatteningStratification, `universalQuotient`/`tautologicalQuotient`/`represents` in GrassmannianQuot) are all accompanied by honest, detailed forward-work descriptions that name specific mathematical dependencies. These are deferred-work notices, not admissions of wrong code.

---

## Severity summary

- **must-fix-this-iter**: 1 — stale scaffold NOTE on `glue` in GrassmannianQuot.lean actively misrepresents a closed construction
- **major**: 1 — contradictory superseded handoff block in SectionGradedRing.lean
- **minor**: 2 — stale STATUS header label (iter-055 vs iter-056); stale ratification notice in FlatteningStratification.lean
- **excuse-comments**: 0

Overall verdict: three files in good shape with no laundered proofs or excuse-comments; one must-fix stale NOTE on `glue` that actively misrepresents a completed construction, one major superseded-block clarity issue, and two minor stale-comment cleanups needed.
