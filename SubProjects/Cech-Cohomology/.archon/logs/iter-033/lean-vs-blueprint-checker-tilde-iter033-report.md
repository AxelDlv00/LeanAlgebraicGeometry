# Lean ↔ Blueprint Check Report

## Slug
tilde-iter033

## Iteration
033

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/TildeExactness.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (blocks around `lem:tilde_preserves_kernels`, L4216–4287; `% NOTE` L4241–4247)

---

## Per-declaration

### `\lean{AlgebraicGeometry.tildePreservesFiniteLimits}` (chapter: `lem:tilde_preserves_kernels`)

- **Lean target exists**: **no** — `AlgebraicGeometry.tildePreservesFiniteLimits` is deliberately absent from `TildeExactness.lean`. The file's module docstring (lines 31–55) explicitly documents two blocking obstructions and names the declaration as the open named target.
- **Signature matches**: N/A — declaration not present.
- **Proof follows sketch**: N/A.
- **Notes**: Absence is honest and intentional. The blueprint `% NOTE` at L4241–4247 accurately states the gap. No `\leanok` is present on the statement block (L4216–4239) or the proof block (L4258–4287), correctly signalling the open status. **No false `\leanok`.**

---

## Unreferenced declarations (informational)

The following three declarations in `TildeExactness.lean` have no corresponding `\lean{...}` reference in the blueprint. All are project-local helpers feeding the eventual proof of the named target.

### `AlgebraicGeometry.tilde_preservesFiniteColimits` (line 73)
- Body: `:= inferInstance`
- **Genuineness check (PASS).** `lean_verify` returns only the standard axioms `{propext, Classical.choice, Quot.sound}` — no `sorry`. Zero warnings (including no unused-variable warnings). The `inferInstance` succeeds because Mathlib provides a `PreservesFiniteColimits (tilde.functor R)` instance via `tilde.adjunction` (left adjoint ⟹ colimit-preservation). This is the right-exactness half of the exactness argument and is substantively non-trivial (it draws on the adjunction API).
- **Blueprint adequacy**: The blueprint prose for `lem:tilde_preserves_kernels` mentions that the tilde functor "preserves colimits" as already known (L4236–4237), so the helper is in scope of the informal discussion, though not `\lean{...}`-pinned. Acceptable.

### `AlgebraicGeometry.tilde_toStalk_map_injective` (line 83)
- Body: `IsLocalizedModule.map_injective _ _ _ _ hf`
- **Genuineness check (PASS).** `lean_verify`: only standard axioms, zero warnings. The signature is non-trivial: it asserts that for an injective `R`-module map `f : M ⟶ N`, the `IsLocalizedModule.map`-assembled localized stalk map `M_𝔭 → N_𝔭` (at any prime `x.asIdeal.primeCompl`) is injective. The proof correctly delegates to `IsLocalizedModule.map_injective`, which formalizes flatness of localization — algebraic content matching the stalkwise-flatness argument in the blueprint proof sketch.
- **Injectivity genuineness**: The conclusion is NOT a trivial restatement. The map is assembled from `(tilde.toStalk M x).hom` and `(tilde.toStalk N x).hom` — the only publicly accessible stalk handle — and the hypothesis `hf : Function.Injective f.hom` is genuinely consumed. This is the flatness core the blueprint's proof sketch describes.
- **Blueprint adequacy**: The blueprint's stalkwise-flatness argument (L4268–4283) informally justifies this injectivity. The helper is not `\lean{...}`-pinned but is clearly a stepping-stone to the named target. Acceptable.

### `AlgebraicGeometry.tilde_preservesFiniteLimits_of_preservesKernels` (line 95)
- Body: `Functor.preservesFiniteLimits_of_preservesKernels _`
- **Genuineness check (PASS).** `lean_verify`: only standard axioms, zero warnings (critically: **no unused-variable warning for `H`**). The hypothesis `H : ∀ {M N : ModuleCat ↑R} (f : M ⟶ N), PreservesLimit (parallelPair f 0) (tilde.functor R)` is genuinely consumed: Lean 4 instance synthesis finds the local `H` in the local context as the discharge for the typeclass argument `[∀ {X Y : C} (f : X ⟶ Y), PreservesLimit (parallelPair f 0) F]` required by `Functor.preservesFiniteLimits_of_preservesKernels` (verified via `lean_hover_info` on the Mathlib lemma — that argument is indeed a typeclass binder). The zero-warning compile confirms `H` is not dead code.
- **Non-vacuousness**: The theorem is a genuine conditional reduction: `H` (kernel-preservation for every `parallelPair f 0`) implies `PreservesFiniteLimits (tilde.functor R)`. The remaining ambient typeclass hypotheses (`Preadditive`, `HasBinaryBiproducts`, `HasFiniteProducts`, `HasEqualizers`, `HasZeroObject`, `PreservesZeroMorphisms`) are all discharged by Mathlib instances for `ModuleCat R` and `(Spec R).Modules`. The theorem correctly isolates the single remaining obligation as a sharply-stated hypothesis.
- **Blueprint adequacy**: The blueprint's reduction step (L4283–4286) informally describes the same logical structure ("the same stalkwise-flatness argument applied to a finite diagram"). The Lean helper makes the categorical reduction machinery explicit (`Functor.preservesFiniteLimits_of_preservesKernels`). Acceptable.

---

## Red flags

**None.** Exhaustive scan:

- No `:= sorry` in any declaration.
- No `:= True`, `:= rfl`, or trivially vacuous bodies.
- No excuse-comments ("TODO replace", "placeholder", "wrong but works").
- No project-local `axiom` declarations.
- No `Classical.choice` on substantive claims (the standard-axioms set `{propext, Classical.choice, Quot.sound}` is the universal Mathlib baseline, present in every theorem that uses classical logic, and is authorized for all of Mathlib-derived work).
- `lean_diagnostic_messages` returns `items: []` — zero errors, zero warnings file-wide.

---

## Blueprint adequacy for this file

- **Coverage**: 1/1 `\lean{...}`-referenced declaration (`AlgebraicGeometry.tildePreservesFiniteLimits`) is correctly marked open (no false `\leanok`). The 3 Lean helpers are unreferenced by `\lean{...}` and are substantively helpers (not top-level targets) — acceptable.
- **Proof-sketch depth**: **under-specified** for Lean formalization, but the gap is honestly flagged. The informal proof (L4258–4287) is mathematically sound (stalkwise-flatness → kernels → finite limits). However it does not address the two Lean-specific barriers that block the named target:
  1. **Ab-valued vs. ModuleCat-valued stalk path**: The stalk API (`toStalkₗ'`, `stalkIsoₗ`, `structurePresheafInModuleCat`) is module-private in Mathlib, forcing an Ab-stalk detour whose germ-naturality transport is ~100–200 LOC of work not previewed in the blueprint.
  2. **Missing categorical glue**: There is no Mathlib lemma "additive + preserves finite colimits + preserves monos ⟹ preserves finite limits". The blueprint doesn't flag this gap.
  These barriers are documented in the Lean file's module docstring (lines 36–54) but not in the blueprint chapter, which weakens the blueprint's usefulness as a standalone guide.
- **Hint precision**: The `\lean{...}` hint `AlgebraicGeometry.tildePreservesFiniteLimits` is precise (names the exact Lean target); the `% NOTE` at L4241 correctly names the same declaration and accurately describes the gap. No wrong hints.
- **Generality**: Matches need.
- **Recommended chapter-side actions** (no must-fix blocking, but for completeness):
  - **minor**: Add a `% NOTE` paragraph inside `\begin{proof}...\end{proof}` of `lem:tilde_preserves_kernels` (after L4258) that explicitly flags the two Lean-specific barriers (Mathlib stalk-API privacy + missing additive-right-exact + preserves-monos ⟹ left-exact lemma). Currently these barriers appear only in the Lean file's module docstring, not in the blueprint.
  - **minor**: Consider adding thin `\lean{...}` stub blocks for the three helper declarations (or at least `tilde_toStalk_map_injective` as the flatness core) so the blueprint's dependency chain is visible; currently the blueprint's formal lemma chain jumps from informal stalkwise-flatness prose directly to the missing named target.

---

## Severity summary

| Finding | Severity |
|---|---|
| Named target `tildePreservesFiniteLimits` absent from Lean file | **not a red flag** — intentional, honestly documented in both `% NOTE` (blueprint) and module docstring (Lean), no false `\leanok` |
| Three helpers unreferenced by `\lean{...}` | **minor** — all are genuine stepping-stone helpers; blueprint prose covers the informal content |
| Blueprint proof sketch silent on two Lean-specific barriers | **minor** — barriers are in Lean docstring; blueprint informal argument is mathematically correct; does not block prover work since the barriers are known |

**No must-fix-this-iter findings. No major findings.**

**Overall verdict**: `TildeExactness.lean` is faithful to its blueprint — all three delivered theorems are genuine, axiom-clean, and non-vacuous; the named target's absence is honestly recorded in both the Lean file and the blueprint `% NOTE` with no false `\leanok`; the only gap is that the blueprint informal proof does not document the two Lean-specific obstructions that block the named target, which is a minor adequacy shortfall already covered by the Lean module docstring.
