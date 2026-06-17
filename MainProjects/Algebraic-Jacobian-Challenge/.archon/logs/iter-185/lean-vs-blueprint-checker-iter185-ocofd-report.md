# Lean ↔ Blueprint Check Report

## Slug
iter185-ocofd

## Iteration
185

## Files audited
- Lean: `AlgebraicJacobian/RiemannRoch/OcOfD.lean`
- Blueprint: `blueprint/src/chapters/RiemannRoch_OcOfD.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.sheafOf}` (chapter: `def:sheafOf`)
- **Lean target exists**: yes (L137)
- **Signature matches**: yes — `(D : C.left.WeilDivisor) → Sheaf (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.{u} kbar)` matches blueprint's described return type.
- **Proof follows sketch**: N/A (definition, not theorem)
- **Body matches blueprint construction**: **partial** — Blueprint describes a uniform subsheaf-of-K_C construction for all D. Lean body is:
  ```lean
  open Classical in
  if D = 0 then Scheme.toModuleKSheaf C else sorry
  ```
  D=0 arm: correctly pins the structure sheaf (`toModuleKSheaf` is the project's `Sheaf J (ModuleCat kbar)` encoding of O_C, confirmed via hover). D≠0 arm: honest `sorry`, construction pending. The body is NOT the general subsheaf-of-K_C construction described in the blueprint; it is a value-pinned case split with the D=0 case hard-coded.
- **`\leanok` on statement block (blueprint L138)**: appropriate — body contains `sorry` in the `else` branch. ✓

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.sheafOf_zero}` (chapter: `lem:sheafOf_zero`)
- **Lean target exists**: yes (L167)
- **Signature matches**: yes — `sheafOf 0 = Scheme.toModuleKSheaf C`. Hover confirms.
- **Proof follows sketch**: **no** — Blueprint proof sketch (blueprint L270–286): "At D=0 the coefficients n_Q = 0, so the section condition reduces to non-negative order = regular; both sides are sub-O_C-modules of K_C with identity restrictions, so presheaf equality promotes to sheaf equality." Lean proof (L169–170):
  ```lean
  unfold sheafOf
  exact if_pos rfl
  ```
  This is a **definitional tautology**: `sheafOf` was defined with `D = 0` pinned to `toModuleKSheaf C`, so `sheafOf 0` unfolds to `if 0 = 0 then toModuleKSheaf C else sorry`, and `if_pos rfl` picks the true branch. The blueprint's mathematical argument (order-condition reduction, structure-sheaf identification) is **not present** in the Lean proof.
- **Sorry propagation** (directive audit): Confirmed — LSP reports `"declaration uses 'sorry'"` at L167 (diagnostic warning), and the goal state after `unfold sheafOf` is `⊢ (if 0 = 0 then toModuleKSheaf C else sorry) = toModuleKSheaf C`. The `sorry` appears because `unfold sheafOf` expands the `else sorry` branch into the proof term. The `if_pos rfl` tactic never evaluates the `else` branch at runtime, but Lean's kernel retains the term. This is honest propagation from `sheafOf`'s body — not sorry laundering. `#print axioms sheafOf_zero` reporting `sorryAx` is explained entirely by this.
- **`\leanok` on statement block (blueprint L253)**: appropriate — declaration exists. ✓
- **`\leanok` on proof block (blueprint L268 `\begin{proof}`)**: absent — correct. `sync_leanok` uses `sorry_analyzer` which detects the transitively-present `sorry`; the proof block correctly lacks `\leanok` and should not receive it until sheafOf's `else sorry` branch is replaced with the actual construction.
- **Fragility**: If sheafOf's body is later replaced with the actual subsheaf-of-K_C construction (as iter-186+ intends), the `unfold sheafOf; exact if_pos rfl` proof will break. A future prover implementing the general sheafOf must simultaneously provide a new proof of sheafOf_zero.

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.sheafOf_singlePoint}` (chapter: `lem:sheafOf_singlePoint`)
- **Lean target exists**: yes (L189)
- **Signature matches**: yes — `sheafOf (C := C) (ofClosedPoint P hP) = lineBundleAtClosedPoint (C := C) P hP hPcoh`
- **Proof follows sketch**: N/A — body is `sorry`, proof not started.
- **notes**: Honest Tier-3 sorry. Cannot be proved until sheafOf's D≠0 case is implemented (with current sheafOf, `sheafOf (ofClosedPoint P hP)` unfolds to `sorry` since a non-zero divisor takes the `else` branch). `\leanok` on statement block (blueprint L289) is appropriate. Untouched per iter-185 directive. ✓

### `\lean{AlgebraicGeometry.Scheme.WeilDivisor.sheafOf_ses_single_add}` (chapter: `lem:sheafOf_ses_single_add`)
- **Lean target exists**: yes (L232)
- **Signature matches**: yes — existential `ShortComplex` with `ShortExact ∧ X₁ = sheafOf D ∧ X₂ = sheafOf (Finsupp.single P 1 + D) ∧ Nonempty (X₃ ≅ skyscraperSheaf P.point (ModuleCat.of kbar kbar))`. Matches blueprint's claim.
- **Proof follows sketch**: N/A — body is `sorry`, proof not started.
- **notes**: Honest Tier-3 sorry. Same gating dependency as `sheafOf_singlePoint` — blocked until sheafOf's general construction is in place. `\leanok` on statement block (blueprint L338) is appropriate. Untouched per iter-185 directive. ✓

---

## Red flags

### Fragile D=0 value-pinning (structural)
- `sheafOf` at L137–141: The body `open Classical in if D = 0 then Scheme.toModuleKSheaf C else sorry` value-pins the D=0 case without constructing the general subsheaf-of-K_C object. The D=0 arm is mathematically correct (`toModuleKSheaf C` IS the structure sheaf), but the definition is a case split rather than the uniform construction the blueprint describes. **Consequence**: when iter-186+ implements the general construction, the current body must be wholesale replaced; the `sheafOf_zero` proof (`unfold sheafOf; exact if_pos rfl`) will simultaneously break and require a new proof from the actual construction.

### sheafOf_zero proof closes by tautology, not by blueprint's mathematical argument
- `sheafOf_zero` at L167–170: The proof is `unfold sheafOf; exact if_pos rfl` — a definitional tautology enabled by the value-pinning in `sheafOf`. The mathematical content of the lemma — that the subsheaf-of-K_C construction at D=0 yields exactly the structure sheaf (via the "non-negative order = regular function" characterization, Hartshorne II§6) — is **not formalized**. The proof merely observes that `sheafOf(0)` was defined to be `toModuleKSheaf C`. The blueprint's proof sketch (blueprint L268–286) is a distinct, more substantial argument that is deferred.

### Linter warning (minor)
- L78: `open scoped Classical` triggers linter `style.openClassical` warning ("please avoid 'open (scoped) Classical' statements"). The `open Classical in` pattern used inside `sheafOf`'s body is style-compliant; the top-level `open scoped Classical` at L78 is the linter target. Not a soundness issue.

---

## \leanok marker audit

| Block | `\leanok` in blueprint | Status | Correct? |
|-------|----------------------|--------|----------|
| `def:sheafOf` statement (L138) | ✓ | body contains `else sorry` | ✓ |
| `lem:sheafOf_zero` statement (L253) | ✓ | declaration exists | ✓ |
| `lem:sheafOf_zero` proof (L268) | absent | transitively sorry via sheafOf else-branch | ✓ — `sync_leanok` correctly withholds it |
| `lem:sheafOf_singlePoint` statement (L289) | ✓ | proof body is sorry | ✓ |
| `lem:sheafOf_singlePoint` proof (L309) | absent | proof body is sorry | ✓ |
| `lem:sheafOf_ses_single_add` statement (L338) | ✓ | proof body is sorry | ✓ |
| `lem:sheafOf_ses_single_add` proof (L380) | absent | proof body is sorry | ✓ |

All seven marker slots are correctly placed. The noteworthy case is `lem:sheafOf_zero`'s proof block: it correctly lacks `\leanok` because `sync_leanok` sees a transitive `sorry` (the LSP confirms `"declaration uses 'sorry'"` at L167). The prover's claim that sheafOf_zero is "closed" is true at the proof-body level only; the transitive state is still sorry-bearing.

---

## Unreferenced declarations (informational)

All four Lean declarations (`sheafOf`, `sheafOf_zero`, `sheafOf_singlePoint`, `sheafOf_ses_single_add`) have corresponding `\lean{...}` blocks in the chapter. No unreferenced substantive declarations.

---

## Blueprint adequacy for this file

- **Coverage**: 4/4 Lean declarations have a `\lean{...}` block. No unreferenced substantive declarations.
- **Proof-sketch depth**: **adequate** — the chapter provides a detailed proof sketch for `sheafOf_zero` (L268–286), a two-beat proof sketch for `sheafOf_ses_single_add` (L384–458 Beat 1 + Beat 2), and a detailed "sheaf-property correctness" section (§4, L460–537) with the full subsheaf-of-K_C recipe. The `sheafOf_singlePoint` sketch (L309–336) is also detailed. No under-specification found.
- **Hint precision**: **precise** — all four `\lean{...}` hints pin the correct fully-qualified names. The blueprint's typeclass package matches the Lean file verbatim. The return type (`Sheaf J (ModuleCat kbar)`) is explicit.
- **Generality**: **matches need** — the chapter blueprints exactly the four declarations the project needs; the "Out of scope" section (§6) explicitly defers items (tensor-additivity, pullback, linear equivalence, Serre duality) not needed for the genus-0 critical path.
- **Recommended chapter-side actions**: none required this iteration. The blueprint is adequate for guiding the iter-186+ general construction. **One forward note**: when the general sheafOf construction is implemented and the if-then-else is replaced, the blueprint's `def:sheafOf` definition block should have its `\leanok` confirmed (it will remain valid); the `lem:sheafOf_zero` proof block will need its `\leanok` added by `sync_leanok` only after the transitive sorry chain is broken.

---

## Severity summary

**must-fix-this-iter**: 0

**major** (2 findings):
1. **sheafOf body — structural divergence from blueprint's uniform construction** (L137–141): The definition is a value-pinned case split (`if D = 0 then ... else sorry`), not the subsheaf-of-K_C construction the blueprint describes. Mathematically correct for D=0 but structurally misaligned with `def:sheafOf`. When iter-186+ implements the general construction, this body must be replaced wholesale, and `sheafOf_zero`'s proof will simultaneously require a new, mathematically substantive argument.
2. **sheafOf_zero proof diverges from blueprint's proof sketch** (L167–170): `unfold sheafOf; exact if_pos rfl` is a definitional tautology. The mathematical content of the lemma (subsheaf-of-K_C at D=0 = structure sheaf, via order-condition reduction) is not formalized. The proof will break when sheafOf is properly implemented.

**minor** (1 finding):
1. Top-level `open scoped Classical` at L78 triggers linter warning. Style-only; no soundness impact.

**Overall verdict**: No must-fix findings; iter-185 legitimately closes `sheafOf_zero`'s proof body (zero own-sorries, honest transitive-sorry from sheafOf's else-branch), but via a structural shortcut (value-pinning + tautological proof) that diverges from the blueprint's mathematical argument and will require replacement when the general sheafOf construction lands — plan agent should flag this coupling to iter-186+ prover directives.
