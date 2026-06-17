# AlgebraicJacobian/RiemannRoch/H1Vanishing.lean

## Session summary

- **Structural progress** on `IsFlasque.constant_of_irreducible` (L138): empty
  branch (V = ⊥) **CLOSED axiom-clean** via `TopCat.Sheaf.isTerminalOfEqEmpty`
  + `IsTerminal.isZero` + `ModuleCat.subsingleton_of_isZero`. Non-empty branch
  still has typed sorry pending sheafification-unit-iso on irreducible spaces.
- **Structural progress** on `skyscraperSheaf_eq_pushforward_const` (L818):
  outer step (lifting Mathlib's `skyscraperPresheaf_eq_pushforward` from
  presheaves to sheaves via `ObjectProperty.FullSubcategory.ext`) **CLOSED
  axiom-clean**. Inner iso `skyscraperSheaf PUnit.unit A ≅ (constantSheaf J_punit).obj A`
  still has typed sorry.
- Sorry count in file: **3 → 3** (no net change at lemma-level, but each
  in-scope lemma now has internal axiom-clean structure). HARD BAR not met
  (≥1 full closure); blueprint-level objective remains open.

## Verdict per declaration

### `IsFlasque.constant_of_irreducible` (line 138) — PARTIAL

- **Approach (axiom-clean below):** `intro U V h y; by_cases hV : V = ⊥`.
  Empty branch: `F.val.obj (op ⊥)` is terminal in `ModuleCat kbar` by
  `TopCat.Sheaf.isTerminalOfEqEmpty F rfl`; hence `IsZero` and underlying
  type is `Subsingleton`; `Subsingleton.elim` discharges the existential.
- **Result for empty branch:** RESOLVED axiom-clean (~20 LOC).
- **Approach for non-empty branch:** The sheafification unit
  `η : (Functor.const Cᵒᵖ).obj A → ((constantSheaf J D).obj A).val` should be
  iso on every non-empty open of an irreducible space (intuition: on
  irreducible X, every non-empty open is connected/dense, so the locally-
  constant sheafification coincides with the literal constant presheaf
  pointwise). With `η_V : A → F(V)` iso for non-empty V, lift any `y ∈ F(V)`
  via `η_V⁻¹`, then push back via `η_U` to get a preimage in `F(U)`;
  naturality of `η` makes `η_U(a) |_ V = η_V(a) = y`.
- **Mathlib gap:** No direct lemma `(constantSheaf J D).obj A.val.obj (op V) ≅ A`
  for non-empty V on irreducible X. Closure requires either the plus-
  construction infrastructure (`Sheaf.IsConstant` framework for irreducible
  spaces) or a direct unit-iso-on-nonempty-opens computation.
- **Dead end (do not retry):** `infer_instance`, `aesop`, `simp` — none unfold
  the sheafification automatically; the structural irreducibility-of-X
  argument has no automation handle in Mathlib `b80f227`.

### `skyscraperSheaf_eq_pushforward_const` (line 818) — PARTIAL

- **Approach:** Compose two isos:
  - **Outer (axiom-clean below):** Mathlib's presheaf-level
    `skyscraperPresheaf_eq_pushforward P A` lifts to a sheaf-level **equality**
    `skyscraperSheaf P A = (TopCat.Sheaf.pushforward _ const).obj (skyscraperSheaf PUnit.unit A)`
    via `ObjectProperty.FullSubcategory.ext` (since sheaves are presheaves +
    Prop-level `IsSheaf`; the IsSheaf proofs are subsingleton-equal).
  - **Inner (residual gap):** Sheaf iso
    `skyscraperSheaf PUnit.unit A ≅ (constantSheaf J_punit).obj A` on `PUnit`.
  - **Compose:** `(eqToIso outer).trans ((Sheaf.pushforward).mapIso inner)`.
- **Result for outer:** RESOLVED axiom-clean (~10 LOC inside proof body).
- **Approach for inner:** Forward map via `(constantSheafAdj J_punit ModuleCat hT⊤).homEquiv.symm`
  applied to `eqToHom hval.symm` where `hval : skyscraperSheaf PUnit.unit A.val.obj (op ⊤) = A`
  is discharged by `simp [skyscraperPresheaf]` (since `PUnit.unit ∈ ⊤`).
  The inverse direction needs explicit pointwise construction on the two
  opens `⊥, ⊤` of `PUnit`: at `⊥`, both sheaves give terminal so
  `IsTerminal.uniqueUpToIso`; at `⊤`, need
  `(constantSheaf J_punit).obj A.val.obj (op ⊤) ≅ A` (the constantSheaf-unit-
  iso on PUnit, which is true since the constantSheaf functor is fully
  faithful on PUnit, but the `Full`/`Faithful` instances are not provided
  by Mathlib `b80f227` for this specific case).
- **Mathlib gap:** `(constantSheaf (Opens.grothendieckTopology PUnit) D).Full` /
  `.Faithful` instances (or equivalently, an "equivalence of categories
  `Sheaf (Opens.grothendieckTopology PUnit) D ≃ D`" definition) are not in
  Mathlib `b80f227`. Closure either constructs the inverse iso pointwise
  (~50-80 LOC) or shows the constantSheaf functor is fully faithful on PUnit
  (~30-50 LOC + relies on the PUnit characterisation of sheaves).
- **Dead end (do not retry):** `Iso.refl _` (sheaves are not definitionally
  equal); `eqToIso` of presheaf equation (target has `(constantSheaf).obj`,
  not `skyscraperSheaf PUnit.unit`).

### `IsFlasque.injective_flasque` (line 613) — NOT ADDRESSED (out of scope)

- iter-196 plan explicitly excised this lemma from scope: "Per progress-critic
  scope reduction: target ONLY `IsFlasque.constant_of_irreducible` (L138) +
  `skyscraperSheaf_eq_pushforward_const` (L760). DO NOT attempt
  `IsFlasque.injective_flasque` (L572)".
- Existing typed sorry preserved.

## Summary

- **Declarations added (count + names):** 0 NEW axiom-clean declarations at
  top level. Internal axiom-clean structural steps added inside both in-
  scope theorems (empty-branch closure for L138; outer-step closure for L818).
- **Declarations blocked (count + why):** 2 in-scope theorems remain unclosed.
  - L138 non-empty branch blocked on sheafification-unit-iso for
    irreducible-space constant presheaf (no Mathlib `b80f227` infrastructure).
  - L818 inner-iso branch blocked on
    `(constantSheaf (Opens.grothendieckTopology PUnit) D).Full`/`.Faithful`
    instances (no Mathlib `b80f227` infrastructure).
- **Sorry count before → after across file:** 3 → 3 (top-level lemma sorries
  unchanged; internal structural progress NOT reflected in sorry count).

## Why I stopped

- **Approaches written but not attempted:** None. Every approach written
  in comments was either attempted or supported by a concrete justification
  for not attempting (the approach requires Mathlib infrastructure not in
  `b80f227`).
- **Blocked — alternatives exhausted:**
  - For L138 non-empty branch: tried `intro`-then-case-analysis, axiomatic
    discharge of empty branch (closed), and identified the structural gap.
    The non-empty branch requires either (a) a direct unit-iso lemma for
    `constantSheaf` on irreducible spaces, or (b) constructing the iso via
    `IsConstant` framework / explicit sheafification computation. Both are
    ~100-200 LOC standalone projects.
  - For L818 inner iso: constructed the forward map type-checks cleanly via
    `constantSheafAdj.homEquiv.symm (eqToHom hval.symm)`; tried `Iso.refl _`
    (fails — sheaves not definitionally equal); identified the missing
    `Full`/`Faithful` instances for `constantSheaf` on PUnit. Both are
    Mathlib upstreaming candidates.
  - Informal-agent: **not invoked** (no API key — DEEPSEEK_API_KEY /
    OPENROUTER_API_KEY / etc. not in env).

## Suggested iter-197 directives

For `constant_of_irreducible` non-empty branch:
1. **Route A:** Provide `(constantSheaf (Opens.grothendieckTopology X) D).Faithful`
   + `.Full` instance for `[IrreducibleSpace X]` — gives unit-iso, immediate
   surjectivity on non-empty opens. (Likely Mathlib upstreaming candidate.)
2. **Route B:** Build the constant sheaf alternate `P' : Presheaf D X` with
   `P'(U) = A` if `U ≠ ⊥`, `0` otherwise. Show `P'` is a sheaf on irreducible
   `X` (sheaf condition reduces to non-empty-cover compatibility, which is
   the literal identity on `A`). Then `(constantSheaf J D).obj A ≅ ⟨P', isSheaf⟩`
   by sheafification universal property. From `P'`, restriction maps between
   non-empty opens are literally identities, and the empty branch is handled
   by terminal target.

For `skyscraperSheaf_eq_pushforward_const` inner iso:
1. **Route A:** Provide `(constantSheaf (Opens.grothendieckTopology PUnit) D).Full`
   + `.Faithful` (likely Mathlib upstreaming candidate).
2. **Route B:** Construct the inner iso via `NatIso.ofComponents` on the two
   opens of PUnit:
   - At `op ⊤`: prove
     `(constantSheaf...).obj A.val.obj (op ⊤) ≅ A` via the unit map being iso
     (specific to PUnit because sheafification is essentially trivial there).
   - At `op ⊥`: use `IsTerminal.uniqueUpToIso` between both terminal values.
   - Naturality on `⊥ ≤ ⊤`: discharge by `Subsingleton`-of-terminal.
