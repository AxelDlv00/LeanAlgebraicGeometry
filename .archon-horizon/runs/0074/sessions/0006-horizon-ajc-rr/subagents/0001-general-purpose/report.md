Confirmed. No standalone surjectivity-of-H0-onto-jumpModule theorem exists; the only surjectivity at that spot is `HModule.exact_map_g_delta` (exactness, not surjectivity) and the pure-field `jumpToResidue_surjective` (which is about the abstract lattice quotient map, not the sheaf-section evaluation map `H⁰(𝒪(D)) → jumpModule`). Now compiling the full report.

## Report: AJCR audit for χ-ledger reuse candidates

All results below are grep/read-verified in `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/`. No file was modified.

**(1) MONOTONICITY/ANTITONICITY of h¹ along divisor increase — EXISTS, exactly as asked.**

File `SectionBound.lean`:
```
theorem h1_le_h1_sub_single {x : X} (hx : x ≠ genericPoint X) (D : X.CurveDivisor) :
    Sheaf.h1 (X.divisorSheaf K D) ≤ Sheaf.h1 (X.divisorSheaf K (D - CurveDivisor.single hx 1))
```
(:67) — plus `h1_add_single_le` (:89, additive form `h¹(𝒪(B+x)) ≤ h¹(𝒪(B))`), `h1_add_nsmul_single_le` (:98), `h1_add_effective_le` (:115, for any effective `E`), and `h1_le_of_effective` (:159, `h¹(𝒪(E)) ≤ h¹(𝒪_X)` for `E ≥ 0`). All are unconditional theorems (no unproved hypotheses), proved from the surjection `Sheaf.HModule.surjective_map_f` on the dévissage SES (the exact "surjectivity of H¹(𝒪(D−x)) → H¹(𝒪(D))" you asked about — it's `Sheaf.HModule.surjective_map_f (devissageSES_shortExact K hx D) 1`, `ChiSlice.lean:126`). No `Subsingleton`-implication form (`Subsingleton H¹(D-x) → Subsingleton H¹(D)`) is stated separately, but it follows trivially from the surjection (one line: surjection from a subsingleton domain forces subsingleton codomain) — see `peel_single` in `FLVClass.lean:260` which does exactly this transport for the effective-witness case.

**(2) SECTION DROP bounds — PARTIALLY EXISTS.**

- `h⁰(𝒪(A)) ≤ max 0 (deg A + h⁰(𝒪_X))` — `h0_divisorSheaf_le_max`, `SectionBound.lean:235`. Unconditional.
- `h⁰(𝒪(A)) ≤ deg A + 1` (linear form, positive-section case) — `h0_le_deg_add_one_of_pos`, `SectionBound.lean:258`, hypotheses `h⁰(𝒪_X)=1` and `0 < h⁰(𝒪(A))`.
- The lower bound `h⁰(𝒪(D−x)) ≤ h⁰(𝒪(D))` is NOT stated directly anywhere (I found no `h0_le_h0` lemma). It's not hard to derive (sections of `D-x` inject into sections of `D`) but it does not exist as a named lemma.
- The dichotomy "drop is 0 or residueDeg" does NOT exist as a general statement. What exists is a *specific instance*: `h0_sub_single_of_rational_nonbase` (`CoverageDrop.lean:141`) proves the drop is exactly 1 at a rational (`residueDeg=1`) non-base point, under hypotheses `H¹(𝒪(W))=0` and non-base-ness — not the general dichotomy for arbitrary `x`.
- The exact formula `drop = residueDeg − (h¹ drop)` is NOT stated as a standalone identity, but it's implicit in `chi_step` (`ChiLedger.lean:76`, unconditional): `χ(𝒪(D)) = χ(𝒪(D−x)) + residueDeg x`, i.e. `h⁰(D) - h¹(D) = h⁰(D-x) - h¹(D-x) + residueDeg x`, which rearranges to exactly your formula. It is a straightforward `omega` away, not already packaged as that formula.

**(3) EVALUATION/JUMP SURJECTIVITY — does NOT exist at the sheaf/H⁰ level; DOES exist at the pure field/lattice level.**

- `jumpToResidue_surjective` (`JumpDimension.lean:251`): `Function.Surjective (jumpToResidue K hx D)`, where `jumpToResidue : pointLattice(coeffAt D) →ₗ[K] residueField x` is a *field-level* map (composite of a valuation shift and the stalk-residue map), unconditional. This is surjectivity of the **abstract jump construction onto κ(x)**, not of the sheaf evaluation map `H⁰(𝒪(D)) → jumpModule`.
- I found **no** theorem of the form `Surjective (jumpProj ... : divisorSections K D U →ₗ[K] jumpModule K hx D)` at any open `U`, and no theorem about surjectivity of the *sheaf* map `devissageπ` at the H⁰ level (only `devissageπ_isLocallySurjective`/epimorphism-of-sheaves, `DevissageExact.lean:192`, which is a sheaf-topos statement, not a statement about global sections `H⁰`).
- Correspondingly, no statement about vanishing of the connecting map `δ : H⁰(sky) → H¹(𝒪(D-x))` exists; what exists is the abstract exactness fact `HModule.exact_map_g_delta` (`ChiSlice.lean:87`), a hypothesis-free *exactness* statement, not a proved vanishing of `δ` for this particular SES.
- **Conclusion: (3) is NOT proved in AJCR at the H⁰/section level.** It would need to be rederived — the ingredients (`jumpProj`, `jumpToResidue_surjective`, the exactness slice) are all present, but the composite surjectivity of `H⁰(𝒪(D)) → jumpModule` is not assembled anywhere.

**(4) UPWARD-CLOSEDNESS OF H¹-VANISHING on the effective cone — EXISTS, as a corollary chain, not literally as one theorem.**

`peel_effective` (`FLVClass.lean:292`, unconditional): `Subsingleton H¹(𝒪(A)) → 0 ≤ E → Subsingleton H¹(𝒪(A+E))`. This is exactly "if h1(D₀)=0 then h1(D)=0 for D = D₀ + E, E effective" i.e. for every `D ≥ D₀` (since `D ≥ D₀ ↔ ∃ E ≥ 0, D = D₀ + E` on Weil divisors). No literal `∀ D ≥ D₀, ...` wrapper exists, but the content is present and proven, unconditionally.

**(5) SECTION-TO-EFFECTIVE-DIVISOR — EXISTS in two forms; h0=0 for deg<0 does NOT exist directly (only via riemann_inequality contrapositive).**

- `exists_effective_of_h0_pos` (`SectionBound.lean:175`, unconditional): `0 < h⁰(𝒪(A)) → ∃ E, 0 ≤ E ∧ picClass E = picClass A`. This is precisely your requested statement (given nonzero section ⟹ D ~ effective divisor), phrased via picClass equality (equivalent to `∃ g, A + div g ≥ 0` — indeed the proof literally constructs `E = A + divOf g`).
- `exists_effective_of_picClass` (`FLVClass.lean:208`) is the analogous statement from a degree hypothesis (`1 ≤ deg W + χ(𝒪)`) via Riemann inequality, rather than directly from `0 < h⁰`.
- `deg A < 0 → h⁰(𝒪(A)) = 0`: NOT stated as its own lemma. It follows immediately by contraposing `exists_effective_of_h0_pos` combined with `deg` monotonicity/nonnegativity of effective divisors, or directly from `riemann_inequality` (`ChiLedger.lean:137`, `deg D + χ(𝒪_X) ≤ h⁰(𝒪(D))`) is the wrong direction — that's a lower bound on h0, not an upper bound forcing 0. Actually the correct route is: `exists_effective_of_h0_pos` gives `deg E = deg A ≥ 0` when `h⁰ > 0` (since `E` effective ⟹ `deg E ≥ 0` and picClass-equal divisors have equal degree, `deg_eq_deg_of_picClass_eq`, `SectionBound.lean:221`), so contrapositive: `deg A < 0 → h⁰(𝒪(A)) = 0`. The pieces exist; the one-line packaged corollary does not.

**(6) UniformVanishing.lean — read in full (117 lines), reported in the earlier turn; summary:**

Main theorem: `AlgebraicGeometry.exists_bound_subsingleton_hModule_one_of_isFinite_toP1` (:71–113):
```
theorem exists_bound_subsingleton_hModule_one_of_isFinite_toP1
    [Module.Finite K (Sheaf.HModule (Y.moduleKSheaf K) 0)]
    [Module.Finite K (Sheaf.HModule (Y.moduleKSheaf K) 1)]
    (π : Y ⟶ P1 K) [IsFinite π] [IsDominant π]
    (hπ : π ≫ P1.structureMap K = Y ↘ Spec (CommRingCat.of K)) :
    ∃ b : ℤ, ∀ D : Y.CurveDivisor, b ≤ CurveDivisor.deg K D →
      Subsingleton (Sheaf.HModule (Y.divisorSheaf K D) 1)
```
This is a **P5-uniform bound**: a single `b` (depending only on `(Y,π)`) such that H¹ vanishes for *every* divisor of degree `≥ b`. It uses exactly the same `CurveDivisor`/`divisorSheaf`/`Sheaf.HModule 1` vocabulary as ChiLedger.lean/ChiSlice.lean — same carrier, no divergence.

**Base case (the crucial question), quoted precisely:** it does **not** derive `H¹ = 0` from scratch, and does **not** compute on P¹ and transport. It **reuses** the FLV-fiber theorem `subsingleton_hModule_divisorSheaf_one_of_isFinite_toP1` (from `FLVVanishing.lean:302`) applied at `D₀ = 0`, obtaining `n₁` such that `Subsingleton H¹(𝒪(n·F))` for `n ≥ n₁`, then specializes to `n = n₁` (`:78-79,105-108` — `hbase := hn₁ n₁ le_rfl`). That FLV-fiber theorem's own base case is a **Noetherian-stabilization argument** (`Submodule.eventually_eq_top_of_monotone_of_iSup_eq_top`, `FLVVanishing.lean:74`) on an exhausting chain of fiber lattices — not a computation "on P¹" and not an assumed hypothesis; it's a genuine, unconditional linear-algebra argument (increasing submodule chain with join `⊤` and Noetherian base quotient stabilizes) applied to the two-cover Čech `H¹` of the fiber-twisted sheaf. The remaining "uniformity in D" step (:80-112 of UniformVanishing.lean) is FLVClass.lean machinery: `zero_lt_deg_fiberWeilDivisor` (surjectivity of finite dominant `π`, unconditional), `exists_effective_of_picClass` (Riemann inequality), and `peel_effective`/`subsingleton_hModule_one_of_picClass_eq` (witness-independence). All ingredients are proven theorems, no unproved hypothesis is smuggled in beyond the two explicit `Module.Finite` instance arguments and `[IsFinite π] [IsDominant π]`.

**(7) Genus/Riemann-Roch ℓ(D) = deg D + 1 − g for large deg D — does NOT exist as a packaged "for deg large" theorem.**

`riemann_inequality_curve` (`ChiCurve.lean`, unconditional) gives only the inequality `deg D + 1 - genus C ≤ h⁰(𝒪(D))`, for *every* `D`, not equality for large degree. The equality form exists only *conditional on H¹-vanishing as an explicit hypothesis*: `h0_eq_deg_add_chi_of_subsingleton_hModule_one` (`FLVClass.lean:412`), `h⁰(𝒪(D)) = deg D + χ(𝒪_Y)` given `Subsingleton H¹(𝒪(D))` as a hypothesis you must supply. Combining this with the UniformVanishing bound `b` from (6) would give you exactly "ℓ(D) = deg D + 1 − g for deg D ≥ b" but **no one has assembled that combination into a single theorem** in AJCR — you'd write roughly 3 lines (`obtain ⟨b, hb⟩ := exists_bound_...; exact fun D hD => h0_eq_deg_add_chi_... D (hb D hD)`) but it isn't currently a named declaration.

Two false-positive traps to flag: `FLVVanishing.lean`'s and `FLVClass.lean`'s vanishing theorems are **per-class, non-effective bounds** (`n₀` depends on the class `l·θⁿ`, not literally "for every D of deg ≥ b" — only `UniformVanishing.lean`'s theorem achieves the fully uniform-in-D form). And the genus `g` throughout AJCR RiemannRoch files is either the frozen `AlgebraicGeometry.genus` (`Challenge.lean:89`, `= dim_k H¹(𝒪_C)`, a definition not an axiom) or an abstract `g : ℕ` parameter with `hχ : χ(𝒪) = 1 - g` as an explicit hypothesis (e.g. `WindowLedgerF3.lean`) — never an unproved standing assumption baked silently into a signature.
