Both repos untouched (the `??` entries are the pre-existing workspace state from the session's initial git status; I wrote only to `/tmp`). All measurements complete.

## (A) Single-field bounded vanishing — EXISTS, twice, and AJC already has its own

**In AJCR:** `AlgebraicGeometry.exists_bound_subsingleton_hModule_one_of_isFinite_toP1`, `RiemannRoch/UniformVanishing.lean:71`. Verbatim conclusion:

```lean
∃ b : ℤ, ∀ D : Y.CurveDivisor, b ≤ CurveDivisor.deg K D →
  Subsingleton (Sheaf.HModule (Y.divisorSheaf K D) 1)
```

Binders: `{K} [Field K] {Y : Scheme} [IsIntegral Y] [Y.Over (Spec (of K))] [SmoothOfRelativeDimension 1 (Y ↘ …)] [LocallyOfFiniteType (Y ↘ …)] [QuasiCompact (Y ↘ …)]`, plus the two properness inputs `[Module.Finite K (Sheaf.HModule (Y.moduleKSheaf K) 0)]` and `[… 1]`, plus `(π : Y ⟶ P1 K) [IsFinite π] [IsDominant π] (hπ : π ≫ P1.structureMap K = Y ↘ Spec (of K))`. This is genuinely (A) and nothing more — the bound is `b = n₁·deg F + 1 − χ(𝒪_Y)`, built from a per-field `Classical.choose`.

Supporting: `subsingleton_hModule_divisorSheaf_one_of_isDominant_toP1` (FLVVanishing.lean:268, per-class `n₀`, both `Module.Finite`) and `…_of_isFinite_toP1` (FLVVanishing.lean:302, discharges the `H¹` one from `IsFinite π`, leaving only the `H⁰` one).

**Not vacuous.** The binder stack is instantiable at a real curve: `Curve/MapToP1.lean:126 exists_isFinite_isDominant_toP1` constructs the finite dominant π with `hπ` on a smooth proper geometrically irreducible curve, and `RiemannRoch/ChiCurve.lean:122` supplies `moduleFinite_hModule_zero` as an instance with `h0_moduleKSheaf = 1` (:135) and `chi_moduleKSheaf = 1 − genus` (:148).

**AJC already has its own (A), independently:** `AlgebraicGeometry.Adelic.exists_bound_subsingleton_h1Mod`, `AlgebraicJacobian/RiemannRoch/Adelic/BoundedVanishing.lean:434`, sorry-free, axiom-clean. Its own docstring states it is "**not** uniform over field extensions and says **nothing** about global generation." It carries three open hypotheses (`hledger`, `hbase`, `hpeel`).

## (B) Extension-uniformity — DOES NOT EXIST as a single uniform bound, and AJCR says so explicitly

No AJCR declaration produces one `N` working for every `K/k`. The blocker is architectural and documented, not an oversight: `WindowFieldTransport.lean:20-24` records that per I-0204's "binding architectural finding, the per-field ledger constants do *not* transport (`windowM_choice` is a per-field `Classical.choose`)".

What exists instead is **fact transport, not bound transport**. `WindowFieldTransport.lean` builds `windowN C K hπ g` (:307) and proves the four transported facts at the base-changed curve:
- `subsingleton_h1_windowN` (:313) — `Subsingleton H¹(𝒪(N))`
- `deg_windowN` (:319) — `deg_K N = M·δ`, with `M = windowM_choice π hπ g` and `δ = windowδ π` **computed at k, not K**
- `two_mul_genus_le_deg_windowN` (:326)
- `subsingleton_h1_windowN_sub` (:362) — `∀ D', deg D' ≤ 2g → Subsingleton H¹(𝒪(N − D'))`
- `h0_windowN` (:336) — `h⁰_K(𝒪(N)) = h⁰_k(𝒪(M·F))`

This is the closest thing to (B) in the workspace and it is a real partial result: because `deg_windowN = M·δ` is a **k-level** quantity, the *numerical* threshold does not depend on `K`. But it delivers vanishing only at the specific transported divisor `N` and at `N − D'` for `deg D' ≤ 2g`, not the statement "∃ N, ∀ K, ∀ D on C×K with deg D ≥ N, H¹ = 0". The generic-D step at level `K` still routes through `subsingleton_hModule_one_of_witness` (`WindowFieldTransport.lean:82`), which needs a witness *and* `χ(𝒪_Y)` at that same field. Genuinely open: quantifying `∃ b, ∀ K, ∀ D` in one statement.

`DegreeBaseFieldInvariance.lean:462 classDeg_cechPicMap_baseFieldTransition` gives `classDeg K₂ (CechPic.map π L) = classDeg K₁ L` — degree invariance under `φ : K₁ →ₐ[k] K₂`. That is the *degree* half of extension-uniformity and it is fully proved; it is not the *vanishing* half.

## (C) Global generation — DOES NOT EXIST in AJCR; AJC already owns it

Zero occurrences of `GloballyGenerated`/`globallyGenerated`/global-generation vocabulary anywhere in AJCR (measured across all 674 .lean files). Not in mathlib's `AlgebraicGeometry` either.

`BpfSpan.lean:70 mulSpan_eq_divisorSections_of_basepointFree` is **not** (C) and must not be read as it. It proves `span(H⁰(𝒪(sF))·T) = H⁰(𝒪((M+s)F − D))` — a *multiplication/span* statement about section spaces, and `hbpf` (basepoint-freeness relative to `MF − D`) is a **hypothesis**, not a conclusion. `BaseDivisor.lean:178 exists_achiever_baseDivisor_sub` produces "no residual base point" only after *subtracting* the base divisor `bd(T)` — true by construction, not a large-degree theorem.

**AJC has (C) natively**, sorry-free and axiom-clean, in `AlgebraicJacobian/RiemannRoch/Adelic/GlobalGeneration.lean`: `GeneratedAt` (:305), `exists_bound_generatedAt` (:424), `exists_bound_forall_generatedAt` (:452), and curve-level `exists_bound_forall_generatedAt_of_isAlgClosed_curve` (`ResidueField.lean:539`). Its own docstring: "It remains **single-field** … nothing here quantifies over field extensions, so extension uniformity is untouched."

## Ranked port cost table

Measured against the real AJC Ledger import graph (36 files, not 35 — `GenusBridge.lean` is AJC-native), counting AJC-native modules as already available.

| # | Target | Extra files | Extra lines | Verdict | Reason |
|---|---|---|---|---|---|
| 1 | **BaseDivisor** | **9** | **2811** | **(a) near-mechanical — PROVEN** | Compiled unchanged. See experiment below. |
| 2 | BaseDivisorSpan | 10 | 3095 | (a) near-mechanical | BaseDivisor + 284 lines; only extra dep `MulEquiv` already ported. |
| 3 | FLVVanishing | 22 | 6519 | (b) port-with-adaptation | 14 `Picard/*` presentation files + 4 FLV files. Bulk is Čech/Pic substrate, mechanical but large. |
| 4 | UniformVanishing | 25 | 7198 | (b) port-with-adaptation | FLVVanishing + FLVClass + ClassCohomology. Delivers (A) only — which AJC already has. |
| 5 | SectionBound | 25 | 7347 | (b) port-with-adaptation | Same closure as UniformVanishing, swapping the 116-line head for 265. |
| 6 | DegreeBaseFieldInvariance | 27 | 7307 | (b) port-with-adaptation | Disjoint substrate: base-change files (`SectionsBaseChange`, `TransitionSectionsBaseChange`, `RelPic`, `ChartColength`). Highest value per line — the only real (B) content. |
| 7 | CoverageDrop | 27 | 7990 | (b) port-with-adaptation | FLVClass closure + BaseDivisor + SectionSpaces. |
| 8 | BpfSpanCore | 29 | 8443 | (b) port-with-adaptation | Adds `AnnihilatorKernel`, `SumIntersection`. |
| 9 | BpfSpan | 47 | 13257 | (c) rederive | Union of the FLV *and* base-change *and* window-ledger closures (`WindowLedger` 479 + `WindowLedgerF3` 171 + `ThetaDegree` + `DegreeBaseFieldInvariance`). Nearly half of AJCR's cohomology substrate. |

Total union across all nine closures: 86 AJCR files.

## The decisive experiment — BaseDivisor ports unchanged

Staged all 9 extra files into `/tmp/stage/AlgebraicJacobian/RiemannRoch/Ledger/`, applied the exact sed rewrite, compiled against AJC's real oleans. **All 9 compiled clean, zero errors, zero warnings, no source edits.** Correct order: `UnitsPresheaf, CechH1, UnitsCocycle, Pic, DivisorClass, MeromorphicPresentation, PresentationDivisor, SectionSpaces, BaseDivisor`.

Two harness notes for whoever repeats this: `lake env lean` **rejects** input files outside the project root ("must be contained in root directory"), so you must call the toolchain `lean` directly (`/home/axel/.elan/toolchains/leanprover--lean4---v4.31.0/bin/lean`) with `-R /tmp/stage`. And `/tmp/out` on `LEAN_PATH` **shadows** the real AJC Ledger oleans — symlink AJC's 35 `.olean`s into the scratch output dir or every ported dependency reports "object file does not exist."

Post-port axiom check in AJC context: `exists_achiever_baseDivisor_sub`, `le_divisorSections_sub_baseDivisor`, `baseDivisor_nonneg`, `baseDivisorAt_sub_baseDivisor_eq_zero` all → `[propext, Classical.choice, Quot.sound]`.

## Sorry-freeness and axioms

All 14 AJCR main declarations across the nine targets report exactly `[propext, Classical.choice, Quot.sound]`. Text scan of the 86-file union found **no** `sorry`/`admit`/`native_decide` except in `AlgebraicJacobian/Challenge.lean` (16 sorries).

**The Challenge.lean sorries are not a threat, and the port already sidesteps them.** They are the Jacobian *statement file* (`Jacobian`, `instGrpObj`, `ofCurve`, `baseChangeIso`, …) — no cohomology content. It entered the closure only via AJCR's `ChiCurve.lean` importing it for `genus`. Your ported AJC `ChiCurve.lean` **dropped that import** and replaced `genus` with a local `ledgerGenus`, with an explicit docstring that the two are `finrank` of *different* `Ext` modules on different sites (`Type u` small-site vs AJC's `Type (u+1)`), "*not* definitionally equal", deferring the comparison to `GenusBridge.lean`. That was the right call and it removes all 16 sorries from every closure. Consequence to keep in view: any AJCR result you port that is stated in terms of `genus` needs `GenusBridge` before it can be composed with AJC's native `genus`.

**Use-site caveat per I-0442.** The clean axiom lines above are declaration-level. `Module.Finite K (Sheaf.HModule (Y.moduleKSheaf K) 0)` and `[… 1]` are instance binders; a use site must synthesise them. On the curve they are discharged (`ChiCurve.lean:122` as an instance; the `1` case from `IsFinite π` via `moduleFinite_hModule_one_of_isFinite_toP1`), so these are satisfiable rather than walls. AJC's `Adelic` lane instead needs `[∀ D, Module.Finite k (sectionSub k ⊤ D)]`, which its own docstring calls open ("The section finiteness is a different matter and remains open").

## No vacuous statements found — but one load-bearing warning

I found **no** unsatisfiable binder stack among the nine AJCR targets. Every one is instantiable at a real curve, and AJCR even ships the non-vacuity witnesses (`MapToP1.lean:126`, `ChiCurve.lean:122`). AJC does the same on its side: `ResidueField.lean:844 exists_degK_ge_of_isAlgClosed_curve` exists specifically to rule out the trivial satisfaction of the `∃ b, ∀ D, b ≤ deg D → …` shape. So this audit does not add a third refutation to the workspace's two.

The real warning is different, and it is about port *value*, not soundness. **AJC's global-generation lane is gated on `hbase` and `hpeel`, and none of the nine AJCR targets supplies either.** I checked every AJC theorem concluding `∃ b, … GeneratedAt`: all six (`GlobalGeneration.lean:424,452,662`; `LedgerClosure.lean:347`; `ResidueField.lean:539,844`) still carry `hbase` and `hpeel` open. Those are stated on AJC's `H1Mod`/`WeilDivisor`/`Peel` carriers; AJCR's results live on `Sheaf.HModule`/`CurveDivisor`/`divisorSheaf`. The carriers are different, so a port does not discharge them.

The practical reading: porting UniformVanishing (#4, 25 files / 7198 lines) would buy AJC a **second, independent** proof of (A) — which AJC already has sorry-free — and would *not* close its (C) gate. If the goal is (B), the only target carrying genuine extension content is **DegreeBaseFieldInvariance** (#6), and even it gives degree invariance, not a uniform vanishing bound. If the goal is a cheap, provably-mechanical win, **BaseDivisor is it** — measured, compiled, 9 files, 2811 lines.
