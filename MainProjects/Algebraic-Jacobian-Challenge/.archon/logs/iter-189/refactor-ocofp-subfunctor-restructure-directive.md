# Refactor Directive

## Slug
ocofp-subfunctor-restructure

## Problem

`AlgebraicJacobian/RiemannRoch/OCofP.lean` Lane A iter-188 outcome:
PARTIAL structural — Case B (non-empty cover) of
`carrierPresheaf_isSheaf` body L512 FAILED on subtype-friction.

Specifically:
- iter-188 prover discovered iter-187 `carrierPresheaf` sheaf-axiom
  violation at `⊥` (carrierSubmodule(op ⊥) = K(C) ≠ 0; empty sieve
  forces F(⊥) = terminal = 0).
- iter-188 prover landed structural fix `carrierSubmoduleSheaf U :=
  carrierSubmodule U ⊓ trivAtBot U` where
  `trivAtBot U := {f | U.unop ≠ ⊥ ∨ f = 0}`. At `U = ⊥`: trivAtBot = ⊥,
  so the intersection is ⊥. At `U ≠ ⊥`: trivAtBot = ⊤, so the
  intersection equals the original.
- Modified `carrierPresheaf` to use the corrected carrier with
  case-based restriction map (zero target on `⊥`; inclusion otherwise).
  Updated downstream consumers (`lineBundleAtClosedPoint`,
  `toFunctionField`, `globalSections_iff_mp`, `globalSections_iff_mpr`)
  via `htop_ne_bot` helper.
- Case A (`iSup U = ⊥`) close LANDED inside body axiom-clean.
- Case B (non-empty cover) FAILED on multiple Lean-API friction
  points:
  - `((ModuleCat.ofHom _).hom _).1` projection without explicit
    ascription fails.
  - `Set ↥C.left` vs `Set ↑C.left.toTopCat` membership-mismatch on
    `Set.mem_iUnion` after `Opens.coe_iSup`.
  - Irreducibility-based gluing requires careful subtype management
    that the existing in-body proof structure makes painful.

iter-188 review's recommendation (carried into iter-189):

> Refactor `carrierPresheaf_isSheaf` via
> `CategoryTheory.Subfunctor` of
> `C.left.toTopCat.presheafToType C.left.functionField`. Existing
> carrier is naturally a Subfunctor (sections = constant functions
> with value in `carrierSubmodule U`); `Subfunctor.isSheaf_iff`
> reduces the sheaf condition to a stalk-locality check, easier via
> irreducibility. Estimated ~80-120 LOC.

## Mathematical justification

The `carrierSubmoduleSheaf` is a sub-presheaf of the constant
function-field sheaf $\underline{K(C)}$ on $C$. The constant
function-field sheaf on an irreducible scheme is the constant
presheaf, and its sub-presheaves correspond bijectively to subsets
of $K(C)$ parametrised by open sets, with monotonicity constraint
(restriction = inclusion).

The cleaner statement is: a sub-presheaf $\mathcal F \subseteq
\underline{X}$ of a constant sheaf $\underline{X}$ on an irreducible
scheme is itself a sheaf iff its underlying assignment $U \mapsto
\mathcal F(U) \subseteq X$ is the section of a Subfunctor (in the
sense of `CategoryTheory.Subfunctor` in Mathlib) of the constant
presheaf.

Mathlib at b80f227 has `CategoryTheory.Subfunctor.isSheaf_iff` (or
equivalent under a slightly different name; verify via
`lean_local_search` / `lean_loogle`): a Subfunctor of a sheaf is a
sheaf iff the stalk condition holds (i.e., is closed under germ
restriction at every point).

For the project's `carrierSubmoduleSheaf`:
- The Subfunctor structure is the underlying Set-valued sub-presheaf
  `U ↦ {f ∈ K(C) : (carrier conditions on U) ∧ (U ≠ ⊥ ∨ f = 0)}`
  inside the constant Type-valued sheaf `_ ↦ K(C)` on `C.left.toTopCat`.
- The stalk condition holds by IRREDUCIBILITY of `C.left`: any two
  non-empty opens intersect, so a section that satisfies the carrier
  conditions on a cover $\{U_i\}$ satisfies them on $\bigsqcup U_i$
  (verify each carrier condition pointwise: a closed point $Q \in
  \bigsqcup U_i$ lies in some $U_i$, and the order condition at $Q$
  holds because it holds in $U_i$).

This refactor replaces the explicit in-body Case B gluing argument
with a Mathlib idiom that handles subtype management uniformly.

## Changes requested

### 1. Restructure `carrierPresheaf` as a Subfunctor

Currently:
```
def carrierPresheaf (P : Scheme.ClosedPoint C.left) :
    (Opens C.left.toTopCat)ᵒᵖ ⥤ ModuleCat.{u} kbar where
  obj U := ModuleCat.of kbar (carrierSubmoduleSheaf U)
  map h := -- case-based restriction; zero if target is ⊥
  ...
```

Replace with two-layer structure:

```
/-- The carrier as a Type-valued sub-presheaf of constant K(C). -/
def carrierTypeSubfunctor (P : Scheme.ClosedPoint C.left) :
    CategoryTheory.Subfunctor
      ((Opens C.left.toTopCat)ᵒᵖ).constant
      (fun (_ : (Opens C.left.toTopCat)ᵒᵖ) => K(C)) where
  obj U := { f : K(C) | (carrier-condition on U.unop) ∧ (U.unop ≠ ⊥ ∨ f = 0) }
  map_mem' := -- monotonicity of carrier-condition + ⊥-handling
  ...

/-- The ModuleCat-valued sub-presheaf, derived from the Type-valued one. -/
def carrierPresheaf (P : Scheme.ClosedPoint C.left) :
    (Opens C.left.toTopCat)ᵒᵖ ⥤ ModuleCat.{u} kbar :=
  -- assemble from carrierTypeSubfunctor by promoting subsets to submodules
  ...
```

The Subfunctor flat structure handles the case-based-on-⊥ uniformly
via the `map_mem'` constraint. The downstream restriction maps
become inclusion-of-submodules everywhere (no per-case dispatch).

### 2. Replace `carrierPresheaf_isSheaf` body with Subfunctor.isSheaf_iff

Current body (~50-100 LOC of in-body Case A + Case B):
```
lemma carrierPresheaf_isSheaf : carrierPresheaf.IsSheaf := by
  rw [TopCat.Presheaf.isSheaf_iff_isSheafUniqueGluing]
  intro ι U sf hcompat
  by_cases h : iSup U = ⊥
  · -- Case A: closed iter-188 axiom-clean
    ...
  · -- Case B: SUBSTRATE — closes via Subfunctor restructure
    sorry
```

Replace with:
```
lemma carrierPresheaf_isSheaf : carrierPresheaf.IsSheaf :=
  -- Use CategoryTheory.Subfunctor.isSheaf_iff (or equivalent) +
  -- stalk-locality check via irreducibility.
  carrierTypeSubfunctor.isSheaf_iff.mpr (by
    intro x
    -- stalk-locality: any germ in the stalk satisfies the carrier
    -- condition iff it satisfies the carrier condition on some
    -- nbhd of x; reduce via irreducibility (any two non-empty
    -- opens intersect).
    ...
  )
```

OR if the Subfunctor route doesn't expose `.isSheaf_iff` directly,
use the cleaner pattern:

```
lemma carrierPresheaf_isSheaf : carrierPresheaf.IsSheaf := by
  -- Subfunctor of a constant Type-sheaf is a sheaf iff the stalk
  -- condition holds (closure under germ restriction).
  apply TopCat.Presheaf.isSheaf_of_isSheaf_subfunctor
    -- or whichever Mathlib lemma exposes the equivalent statement
  · exact constantSheaf_isSheaf K(C)
  · -- stalk-locality via irreducibility
    ...
```

Implement the refactor; close Case B via the cleaner approach;
preserve the Case A logic (`iSup U = ⊥ → s = 0`) inside the new
proof structure.

### 3. Update downstream consumers

`lineBundleAtClosedPoint`, `toFunctionField`, `globalSections_iff_mp`,
`globalSections_iff_mpr` already use the iter-188 `htop_ne_bot` helper
to supply the trivAtBot witness at `op ⊤`. With the Subfunctor
restructure, these helpers should be reusable verbatim — the carrier
SET at `⊤` is the same (since `⊤ ≠ ⊥`). Verify no signature changes
in the downstream API.

If the Subfunctor restructure changes the `def carrierPresheaf` type
signature (e.g., now returning a `Subfunctor` instead of an
unbundled `Functor`), update consumers to extract the
`.toFunctor`-equivalent value as needed.

## Affected files

- `AlgebraicJacobian/RiemannRoch/OCofP.lean` — primary file.
- No other `.lean` files depend on the internal structure of
  `carrierPresheaf` (the consumers above are inside the same file).
- Blueprint chapter `RiemannRoch_OCofP.tex` — already updated this
  iter (iter-189 plan-phase direct edit landed
  `def:lineBundleAtClosedPoint_carrierSubmoduleSheaf` pin). The new
  Subfunctor structure is internal and does not require additional
  blueprint changes; the existing `def:lineBundleAtClosedPoint_carrierPresheaf`
  pin still applies to the outer `carrierPresheaf` declaration.

## Expected outcome

- File compiles GREEN.
- `carrierPresheaf_isSheaf` body closes axiom-clean OR carries 1
  narrow named typed sorry on the stalk-locality step (if Mathlib's
  Subfunctor.isSheaf_iff is unavailable, you may leave the
  stalk-locality step as a named typed sorry — but at most 1).
- Case A (`iSup U = ⊥ → s = 0`) preserved or absorbed naturally
  into the new structure.
- Downstream consumers (`lineBundleAtClosedPoint`, `toFunctionField`,
  `globalSections_iff_*`) remain axiom-clean modulo the same
  named sorries they currently have.
- Net sorry count on file: 4 → 3 or 4 → 4 (refactor net zero) but
  with the substrate localized via Subfunctor.

## Estimate

~80-120 LOC of refactor LOC. ~1 iter of refactor budget.

## Reference

- Mathlib `CategoryTheory.Subfunctor` namespace (verify location at
  b80f227 via `lean_local_search Subfunctor`).
- iter-188 task result `AlgebraicJacobian_RiemannRoch_OCofP.lean.md`
  for the iter-188 attempt forensics + Case A details to preserve.
