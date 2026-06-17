# Session 2 (iter-002) — Review Summary

First prover-dispatch iter of the subproject. Two lanes ran: **FBC-A**
(`Cohomology/FlatBaseChange.lean`) and **GF** (`Picard/FlatteningStratification.lean`).
Build is **GREEN** (zero errors; only `sorry` warnings). All work is honest — real
statements with `sorry` bodies, plus one fully-proved lemma; no fake/placeholder
statements, no type-weakening dodges.

- Sorry-bearing decls before → after: FBC-A 2 → 3 (but +1 fully-proved lemma added),
  GF 1 → 2. The increases are *structural*: each lane converted a monolithic sorry
  into named sub-lemmas (one of which, in FBC-A, is now closed), making the residual
  obligations explicit and independently attackable.
- `dag-query gaps` = 0 (no ∞ holes), `frontier` = 0 ready, blueprint-doctor clean.

## FBC-A lane — `Cohomology/FlatBaseChange.lean`

Objectives: (a) create `pushforward_base_change_mate_cancelBaseChange`,
(b) create `base_change_map_affine_local`, (c) wire `affineBaseChange_pushforward_iso`.

### `base_change_map_affine_local` (obj b) — SOLVED ✅
One-liner: the blueprint's intended signature is exactly the `.mpr` direction of the
already-proved locality criterion `Modules.isIso_iff_isIso_app_affineOpens`.
```lean
(Modules.isIso_iff_isIso_app_affineOpens (pushforwardBaseChangeMap f g f' g' h.w F)).mpr H
```
`lean_verify`: axioms `[propext, Classical.choice, Quot.sound]`, no `sorry`. The locality
reduction is not new content; the substance is the per-open hypothesis `H` (= the
affine–affine section assertion, supplied per-chart by obj a).

### `pushforward_base_change_mate_cancelBaseChange` (obj a) — PARTIAL (statement landed, proof = crux sorry)
Stated in the affine–affine model (`ψ : R ⟶ R'`, `φ : R ⟶ A` in `CommRingCat`,
`M : ModuleCat A`) over the generic pullback square `pullback (Spec.map φ) (Spec.map ψ)`.
Statement typechecks (`lean_verify`: `[propext, sorryAx, Classical.choice, Quot.sound]`).

**Deliberate signature choice (flagged by prover, reviewed):** the Lean decl formalizes
the `IsIso (Γ(α))` *consequence*, not the blueprint's literal equality
`Θ_tgt ∘ Γ(α) ∘ Θ_src⁻¹ = cancelBaseChange⁻¹`. Rationale: stating the equality requires
identifying `pullback.fst`/`pullback.snd` over the generic square with the
`Spec`-of-tensor inclusions via `pullbackSpecIso` — the *same* plumbing that blocks the
proof. The `IsIso` form is faithful, non-vacuous (`unfold` exposes the real
`Γ(pushforwardBaseChangeMap …)`, not a tautology), and is exactly what the affine close
consumes. **Accepted** as the formalization; I added a `% NOTE:` to the blueprint block
reconciling the pin (see Blueprint markers).

**Blocker / crux:** the mate-unwinding coherence over the generic square. `pullback.fst/snd`
are not definitionally `Spec.map` of the tensor inclusions, so the two `Spec`-map tilde
dictionaries (`pushforward_spec_tilde_iso`, `pullback_spec_tilde_iso`) do not directly
apply to `f'/g'`. Identify them via `pullbackSpecIso` (+ `_hom_fst/_hom_snd/_inv_fst`),
then unwind the `pullbackPushforwardAdjunction`-transpose on `Γ` through the four
dictionaries onto `cancelBaseChange⁻¹` (orientation `r' ⊗ m ↦ (r' ⊗ 1) ⊗ m`, from
`cancelBaseChange_symm_tmul`). This is the genuine Mathlib-absent crux.

### `affineBaseChange_pushforward_iso` (obj c) — PARTIAL (rerouted)
Replaced the inline `rw [Modules.isIso_iff_isIso_app_affineOpens]; intro U` with
`apply base_change_map_affine_local f g f' g' h F; intro U`, routing the first reduction
through the new named lemma. The remaining `sorry` is now ONLY the **affine reduction**
(obligation 1): the ambient `S,S',X,X'` are arbitrary, so one must restrict the square
over `U = Spec R' ⊆ S'` and a chosen affine `Spec R ⊆ S` containing `g(U)`, identify
`(pushforwardBaseChangeMap …).app U` with the restricted affine–affine map, then apply
obj a via the tilde–Γ counit. The restriction-compatibility of `pushforwardBaseChangeMap`
is Mathlib-absent. Stale iter-242 comment block updated.

### `flatBaseChange_pushforward_isIso` (FBC-B) — UNTOUCHED
H⁰-equalizer globalization, deferred to a later lane per PROGRESS. Not churned.

## GF lane — `Picard/FlatteningStratification.lean`

Objectives: (a) create `genericFlatnessAlgebraic`, (b) re-sign `genericFlatness`,
(c) prove the GF-geo wrapper.

### `genericFlatnessAlgebraic` (obj a) — PARTIAL (primary branch closed, dévissage residue sorry)
Created with EXACTLY the blueprint `% INTENDED LEAN SIGNATURE` (noetherian domain `A`,
finite-type `A`-algebra `B`, finite `B`-module `M` via scalar tower). Body splits
`by_cases hAM : Module.Finite A M`:
- **Primary route (CLOSED, axiom-clean):** `M` module-finite over `A` ⟹
  `exact GenericFreeness.exists_free_localizationAway_of_finite A M`.
- **Residue (SORRY):** `M` finite over the finite-type `B` but not module-finite over `A`
  — the Nitsure §4 dévissage. Reduces to the *polynomial-ring core* (a finite module over
  `A[X₁..X_d]` is generically free), which Mathlib does NOT supply (verified absent via
  `lean_leansearch`). Pin `thm:generic_flatness_algebraic` now resolves.

### `genericFlatness` (obj b re-sign + obj c wrapper) — PARTIAL
- **Re-sign (DONE):** added `[F.IsQuasicoherent] [F.IsFiniteType]` per the corrected
  intended signature (these were the missing piece making the prior signature
  false-as-written — no `IsCoherent` predicate at this pin). Not protected; grep confirms
  no external references, so the re-sign is safe.
- **Wrapper (PARTIAL):** established the genuine starting point —
  `IsIntegral.nonempty` → pick `x₀` → `exists_isAffineOpen_mem_and_subset` gives a
  non-empty affine open `U₀ ⊆ S` with `A := Γ(S,U₀)` a noetherian domain. (One typo
  fixed mid-session: `Opens.mem_top x₀` → `by trivial`.) Globalization is the isolated
  sorry; the prover deliberately did NOT `refine ⟨V,…⟩` with a placeholder V because an
  arbitrary `V` makes the flatness goal false — the witness must be `V = D(∏ f_j)` from
  the per-patch `genericFlatnessAlgebraic` outputs.

## Key findings / patterns

- **Locality-criterion lemmas are `.mpr` one-liners.** `base_change_map_affine_local` shows
  a "reduce to affine opens" lemma is just the backward direction of an existing
  `isIso_iff_isIso_app_affineOpens`-style criterion; the real content is the per-open
  hypothesis, which is a *separate* objective. Cheap to extract, sharpens the residual.
- **Formalize the consumable consequence when stating the equality needs the same blocked
  plumbing.** The `IsIso (Γ(α))` choice over the literal equality avoided a circular
  plumbing dependency without weakening content (`unfold` test passes).
- **`by_cases Module.Finite A M` cleanly splits generic flatness** into the
  already-proved finite-module helper and the genuinely-deep finite-type dévissage —
  closing real ground (the primary branch) while isolating the hard residue.

## Blueprint markers updated (manual)

- `Cohomology_FlatBaseChange.tex`, `lem:pushforward_base_change_mate_cancelBaseChange`:
  added `% NOTE:` recording that the Lean decl is the `IsIso (Γ(α))` corollary, not the
  literal equality, and why (pullbackSpecIso plumbing is shared with the proof crux).

`sync_leanok` (iter 2, sha `693855e`) added 4 statement-`\leanok` markers across the two
chapters and removed 0 — its deterministic verdict; not flagged as laundering (the new
decls genuinely compile, proofs carry `sorry` so proof-blocks stay unmarked). No
`\mathlibok` added this iter (the two pre-existing anchors were verified faithful by the
plan-phase blueprint-reviewer). No `\lean{...}` rename needed (both new decls match their
pins verbatim). No stale `\notready` found.

## Coverage debt (for planner — see recommendations.md)

`dag-query unmatched` = 4 `lean_aux` nodes with no blueprint entry:
`GenericFreeness.exists_flat_localizationAway_of_finite`,
`GenericFreeness.exists_free_localizationAway_of_finite`,
`GenericFreeness.exists_free_localizationAway_of_moduleFinite`,
`gammaPushforwardNatIso`. All pre-existing (not created this iter); still need thin
blueprint entries to restore 1:1 graph correspondence.

## Subagent skips

(none — both highly-recommended review subagents dispatched; see review.md)
