# Brick spec — χ-ledger close: G8 (h⁰/h¹/χ + finiteness dévissage + chi_step/chi_divisorSheaf) and G9 (Riemann–Roch-lite)

*Written 2026-07-14 (Fable orchestrator). Consumer: one Fable implementation agent — these
are the ★ ledger keystones of the Wave-2b χ-ledger (`AJCR.w2-chi.ledger` + `AJCR.w2-chi.rr`),
the last two gaps of the recon `informal/zeta-w2b-chi-recon.md` (§3, G8/G9). Every geometric
input is LANDED and committed (root build 8667 jobs); this brick is the linear-algebra
assembly on top. The deliverable CONTRACT is binding; the route below is the designed one,
but you own the organization.*

## Read first (in this order — 15 minutes that save hours)

1. The four API-map dumps (VERBATIM landed signatures, machine-extracted this session —
   trust them over this spec's abbreviations, and the source over both):
   - `informal/api-chi-cohomology.md` — `Sheaf.HModule` carrier, `HModule.map` (+`map_id_apply`/`map_comp_apply`),
     `linearEquiv₀`, `moduleKSheafHZero`, finiteness, TwoCover. **Read its Warnings list in full.**
   - `informal/api-chi-devissage.md` — `divisorSheaf`, `divisorSheafZeroIso`, `devissageSES`(+`_shortExact`),
     `jumpModule`/`finrank_jumpModule`, `mulEquivDivisorSheaf`. **Read its Conventions + Warnings in full.**
   - `informal/api-chi-divisors.md` — `CurveDivisor` (opaque wrapper!), `deg`, `divOf`, `residueDeg`, `ord`.
   - `informal/api-chi-genus.md` — frozen `genus`, `moduleFinite_hModule_one` (the `letI` keying!),
     `exists_isFinite_toP1`, Γ(C,𝒪)≅k pieces, roadmap-leaf wording.
2. `informal/zeta-w2b-chi-recon.md` §3 (G8/G9) — the design.
3. `Cohomology/AffineVanishing.lean:71` (`subsingleton_one_of_injective_of_surjective`) —
   the IN-TREE EXEMPLAR of consuming mathlib's `Abelian.Ext.covariant_sequence_exact*` API
   elementwise. Your six-term slice uses the same idiom.

## The two-convention junction (pinned — do not rediscover it)

The tree has two coexisting variable conventions, and this brick sits exactly at their seam:

- **RiemannRoch layer (where your inputs live):** unbundled `X : Scheme.{u}` over an
  uppercase base field, `(K : Type u) [Field K] {X : Scheme.{u}} [X.Over (Spec (CommRingCat.of K))]
  [SmoothOfRelativeDimension 1 (X ↘ Spec (CommRingCat.of K))] [IsIntegral X]`, plus
  `[QuasiCompact (X ↘ …)]` for `devissageSES_shortExact` and `[LocallyOfFiniteType (X ↘ …)]`
  for `finrank_jumpModule`/`moduleFinite_jumpModule`; `mulEquivDivisorSheaf` needs BOTH.
  K-module structures are sealed local instances (`Scheme.functionFieldOverModule`,
  `Scheme.overModule`, `Scheme.residueFieldOverModule`) activated per-file via
  `attribute [local instance]`.
- **Cohomology/Challenge layer (where finiteness and genus live):** bundled curve
  `C : Over (Spec (.of k))` (lowercase k), standing bundle `[SmoothOfRelativeDimension 1 C.hom]
  [IsProper C.hom] [GeometricallyIrreducible C.hom]`, unbundled via the EXACT spelling
  `letI : C.left.Over (Spec (.of k)) := .ofHom C.hom`. The instance
  `moduleFinite_hModule_one` (H¹(𝒪) finite) is deliberately keyed on that identical `letI`
  spelling — respell it and the instance will NOT fire.

**Architecture decision (binding):** two layers.

- **Layer A (general conditional ledger)** — everything stated in the RiemannRoch convention
  on unbundled `X`, with the two base-case finiteness facts taken as INSTANCE-ARGUMENT
  hypotheses: `[Module.Finite K (Sheaf.HModule (X.moduleKSheaf K) 0)]` and
  `[Module.Finite K (Sheaf.HModule (X.moduleKSheaf K) 1)]`. (They are genuinely extra: an
  affine curve satisfies every other hypothesis and has infinite-dimensional H⁰. Properness
  enters ONLY through these two.)
- **Layer B (curve instantiation)** — on the bundled `C` under the `letI` spelling: supply
  those two instances (H¹ = `moduleFinite_hModule_one`; H⁰ via Γ(C,𝒪) ≅ k below), then
  state the headline curve corollaries in terms of the frozen `genus C`
  (`Challenge.lean:89` = `Module.finrank k (Sheaf.HModule (C.left.moduleKSheaf k) 1)`).
  Check that `IsProper C.hom` yields the `QuasiCompact`/`LocallyOfFiniteType` instances
  Layer A needs (mathlib derives both from properness; verify they fire, add the tiny
  `instance`/`haveI` bridges if not).

## Mission

**Deliverable contract** (final names yours to make mathlib-quality; shapes binding):

*Layer A — general, `RiemannRoch/Chi*.lean`, hypotheses as in the junction section:*

1. `h0 F : ℕ`, `h1 F : ℕ`, `chi F : ℤ` for `F : Sheaf (Opens.grothendieckTopology X) (ModuleCat.{u} K)`
   — `h0 F := Module.finrank K (Sheaf.HModule F 0)`, `h1 F := … 1`, `chi F := (h0 F : ℤ) - h1 F`.
   (These can live at the general-sheaf level, `CategoryTheory.Sheaf` namespace, if you
   prefer — nothing about them is scheme-specific. Your call; report it.)
2. `h0_congr`/`h1_congr`/`chi_congr` from a sheaf iso `F ≅ G`. NO prebuilt transport exists:
   build the `LinearEquiv` from `HModule.map e.hom`/`HModule.map e.inv` +
   `map_comp_apply`/`map_id_apply` once, generally, then take `finrank_eq`.
3. **Finiteness dévissage**: `Module.Finite K (Sheaf.HModule (X.divisorSheaf K D) i)` for
   `i = 0, 1` and every `D : X.CurveDivisor`, registered so downstream `finrank` arithmetic
   fires (instance with parameter `D`, or lemmas + `haveI` at use sites — your call).
4. `chi_step : chi (X.divisorSheaf K D) = chi (X.divisorSheaf K (D - single ⟨x,hx⟩ 1)) + residueDeg K x`
   — spelled against the EXACT divisor the landed SES uses (`devissageSES K hx D` has first
   term `𝒪(D − single ⟨x,hx⟩ 1)`; check `Devissage.lean`'s `devissageDivisor` spelling and
   state against it, adding a human-readable restatement if the spellings differ).
5. `chi_divisorSheaf : chi (X.divisorSheaf K D) = chi (X.moduleKSheaf K) + deg K D`.
6. `deg_divOf : deg K (Scheme.divOf (X ↘ Spec (CommRingCat.of K)) g) = 0` for
   `g : X.functionFieldˣ`.
7. `riemann_inequality : deg K D + chi (X.moduleKSheaf K) ≤ (h0 (X.divisorSheaf K D) : ℤ)`
   (from `h1 ≥ 0` + item 5 — state the general form with `chi (moduleKSheaf)`; the
   `1 − genus` form is Layer B's).
8. `h0_nsmul_point_unbounded : ∀ N : ℕ, ∃ n : ℕ, N ≤ h0 (X.divisorSheaf K (n • single ⟨x,hx⟩ 1))`
   (uses `residueDeg_pos`; no rational point needed).

*Layer B — bundled curve `C`, connecting to the frozen `genus`:*

9. The two `Module.Finite` instances for `C.left.moduleKSheaf k` degrees 0 and 1 under the
   `letI := .ofHom C.hom` spelling (H⁰ finite — indeed 1-dimensional — via Γ(C,𝒪) ≅ k).
10. `h0_moduleKSheaf : h0 (C.left.moduleKSheaf k) = 1` — no prebuilt composite exists: chain
    `Scheme.moduleKSheafHZero` (H⁰ ≃ₗ[k] Γ(C.left,⊤)) with `asIso C.hom.appTop` (iso by
    `isIso_hom_appTop_of_geometricallyReduced`, `Curve/Sections.lean` — geometrically
    reduced comes from smoothness; check how the landed file phrases it) and
    `Scheme.ΓSpecIso`. Mind that the composite must be k-LINEAR: the ring isos must be
    upgraded through `Scheme.overModule`/`overAlgebraMap` compatibility — budget a real
    lemma here, this is the one place in the brick with genuine seam-crossing.
11. `chi_structureSheaf : chi (C.left.moduleKSheaf k) = 1 - genus C` (in ℤ; from 10 + the
    definition of `genus`).
12. Curve forms of 7/8, e.g. `deg k D + 1 - genus C ≤ h0 …` — one-line consequences, but
    they are what the blueprint cites, so state them.

All kernel-green, axiom-clean (exactly `[propext, Classical.choice, Quot.sound]`), no sorry.
This CLOSES the χ-ledger: `AJCR.w2-chi.ledger` and `AJCR.w2-chi.rr` become done.

**Staged fallback (acceptable landings, in order):** (1) full contract; (2) Layer A complete,
Layer B frontier reported; (3) items 1–4 (the ledger leaf `chi_step`); (4) the largest green
committed-ready prefix with a precise frontier report. Never a red tree, never a sorry in
the final state.

## The designed route

**(a) Definitions + congruence** (items 1–2). Small and general; put the `LinearEquiv`-from-iso
constructor next to `HModule.map`-style code (one general def, used everywhere after).

**(b) The six-term slice, packaged ONCE.** From `devissageSES_shortExact K hx D` (shape:
`0 → 𝒪(D − x) → 𝒪(D) → skyModule x (jumpModule K hx D) → 0`, needs `[QuasiCompact]`) extract
the five elementwise facts the alt-sum lemma wants, via mathlib's covariant Ext sequence
(exemplar: `AffineVanishing.lean:71`):
- `Function.Exact` at H⁰(𝒪(D)), at H⁰(sky), at H¹(𝒪(D−x)), at H¹(𝒪(D)) — mathlib's
  `Abelian.Ext.covariant_sequence_exact₂` (n=0), `…exact₃'`, `…exact₁'`, `…exact₂` (n=1)
  applied to the SES, transported across `HModule.map` (definitionally `Ext`-postcomposition
  — `map_apply` is `rfl`; the transport should be cheap, but do it in ONE named lemma per
  slot, never inline).
- Injectivity of H⁰(𝒪(D−x)) → H⁰(𝒪(D)): through `linearEquiv₀`-naturality
  (`HModule.linearEquiv₀_naturality`), postcomposition with the mono `(devissageSES …).f`
  on `Hom(const, ·)` is injective by `cancel_mono`; or extract it from mathlib's sequence
  API if it has the degree-0 left-end lemma — search first (`lean_loogle`,
  `Ext`-named lemmas around `covariant_sequence`).
- Surjectivity of H¹(𝒪(D−x)) → H¹(𝒪(D)): exactness at H¹(𝒪(D)) + the instance
  `skyModule_subsingleton_hModule_one` (map INTO a subsingleton has kernel ⊤).
Package: one opaque def/lemma bundle per slice (the kernel discipline — the slice gets
consumed twice: finiteness step + chi_step; NEVER re-derive it inline).

**(c) Finiteness dévissage** (item 3). Predicate `P D := Module.Finite … 0 ∧ Module.Finite … 1`.
- Base `P 0`: transport along `divisorSheafZeroIso : divisorSheaf K 0 ≅ X.moduleKSheaf K`
  (direction as landed; mirror `moduleKSheafDivisorSheafZeroIso` also exists) using the
  item-2 `LinearEquiv` + the two hypothesis instances.
- Step BOTH WAYS from the (b) slice at `(D, x)` — `Module.Finite` closure facts (all in
  mathlib; search before proving): submodule of finite over a field, image, quotient,
  extension (`ker` finite + `range` finite ⇒ domain finite — via rank-nullity or
  `Module.Finite.of_exact`-style lemmas; `lean_loogle` for exact names).
  - up (`P (D−x) → P D`): H⁰(D) — kernel lands in image of finite H⁰(D−x)… cleanest as:
    H⁰(D)/im ↪ H⁰(sky) finite (`moduleFinite_jumpModule` + `skyModuleGammaEquiv`), im finite
    ⇒ H⁰(D) finite. H¹(D): quotient of finite H¹(D−x) (the (b) surjectivity).
  - down (`P D → P (D−x)`): H⁰(D−x) ↪ H⁰(D) ((b) injectivity). H¹(D−x): kernel of
    H¹(D−x)→H¹(D) = image of finite H⁰(sky) (exactness), cokernel-side embeds in finite
    H¹(D) — extension argument again.
- **Induction scaffolding**: ONE reusable principle, e.g.
  `CurveDivisor.induction_on_single : P 0 → (∀ D x hx, P D ↔ P (D - single ⟨x,hx⟩ 1)) → ∀ D, P D`
  (measure: `(toFinsupp D).sum fun _ n => n.natAbs`, or `Finsupp.induction` + per-point
  ℤ-recursion — your choice; it is reused verbatim by (e)). CurveDivisor is an OPAQUE
  wrapper over Finsupp — go through `toFinsupp`/`coeffAt` for coefficients; the
  AddCommGroup/PartialOrder instances are inherited. Keep the scaffolding its own small
  section — do NOT entangle it with cohomology.

**(d) `chi_step`** (item 4). Feed `finrank_alt_sum_eq_zero_of_exact₅`
(`Algebra/DedekindColength.lean:78`; shape: five `Module.Finite` k-modules, four `→ₗ[k]`
maps, `Function.Injective f₁`, three `Function.Exact`, `Function.Surjective f₄`, conclusion
in ℤ) with the (b) slice + (c) finiteness. Then
`h0 (sky) = finrank (jumpModule) = residueDeg K x` by `skyModuleGammaEquiv` +
`finrank_jumpModule` (needs `[LocallyOfFiniteType]`), and `h1 (sky) = 0` by the subsingleton
instance. Push ℕ→ℤ casts once (`push_cast`/`omega` at the end, not cast juggling throughout).

**(e) `chi_divisorSheaf`** (item 5): the (c) induction principle with
`P D := (chi (divisorSheaf K D) = chi (moduleKSheaf K) + deg K D)`; base by `chi_congr`
`divisorSheafZeroIso` + `deg_zero`; step by `chi_step` + `deg` arithmetic (`deg_add`,
`deg_single`, `deg_neg` — see the divisors dump; `deg` is defined at `[CommRing K]`
generality, fine).

**(f) `deg_divOf`** (item 6): `mulEquivDivisorSheaf K g D : divisorSheaf K D ≅
divisorSheaf K (D - divOf … g)` (a sheaf iso; needs LFT + QC). Take `chi_congr`, expand both
sides by (e), cancel: `deg K D = deg K (D - divOf g)` ⇒ `deg K (divOf g) = 0` by `deg_add`/
`deg_neg`. Any `D` works — use `D = 0`.

**(g) G9 + Layer B** (items 7–12). `riemann_inequality`: `chi ≤ h0` since `h1 ≥ 0`, then (e).
`h0_nsmul_point_unbounded`: `deg (n • single ⟨x,hx⟩ 1) = n * residueDeg K x ≥ n * 1`
(`residueDeg_pos` — statement in the divisors dump), so `h0 ≥ n + chi(𝒪)`; choose
`n := N + (h1 (moduleKSheaf) : ℕ)` and mind the ℤ/ℕ seam. Layer B per the junction section;
item 10 is the only genuinely new proof here — the k-linear Γ ≅ k composite.

## Constraints (binding — the kernel discipline)

- Opaque `def`s/named lemmas for the (b) slice and every transport; NO `rw`/`simp only ... at`
  on hypotheses mentioning concrete curve/Spec towers; abstract lemma (small types)
  instantiated once for anything rewrite-heavy.
- `(kernel) deterministic timeout` ignores maxHeartbeats — restructure, don't raise.
- Doc-comments AFTER `set_option ... in`; no binders with local-notation types in `variable`
  commands (declarations silently vanish — verify per-constant); `set_option autoImplicit false`.
- Respect the sealed-local-instance discipline: activate `Scheme.overModule`/
  `functionFieldOverModule`/`residueFieldOverModule` via `attribute [local instance]` per
  file exactly as the RiemannRoch files do; NEVER make them global.
- Files ≤ 500 lines (suggested split: `RiemannRoch/Chi.lean` (defs+congr),
  `RiemannRoch/ChiSlice.lean` or merged (the (b) slice), `RiemannRoch/ChiFiniteness.lean`
  (scaffolding + dévissage), `RiemannRoch/RiemannRochLite.lean` (chi_step through G9),
  `RiemannRoch/ChiCurve.lean` (Layer B) — reorganize freely under 500).
- Mathlib naming + complete docstrings; no new axioms; do NOT touch `Challenge.lean`
  (read-only consumer of `genus`); wire new files into `AlgebraicJacobian.lean` (on
  staleness: re-read and re-apply just your lines).
- Search before proving (lean_local_search / lean_loogle / lean_leansearch): the
  `Module.Finite`/finrank closure steps and the Ext-sequence endpoints almost certainly
  exist — in mathlib or in-tree.
- ONE build at a time: iterate with the lean-lsp MCP; never run `lake build` while the LSP
  is loading; never two lake builds.

## Verification (FOREGROUND, non-negotiable)

When done: root `lake build` blocked to completion in the FOREGROUND (paste the tail),
`lean_verify` (lean-lsp MCP — NOT `lake env lean` scratch files, they OOM) on `chi_step`,
`chi_divisorSheaf`, `chi_structureSheaf` (Layer B), `deg_divOf`, `riemann_inequality`,
`h0_nsmul_point_unbounded`, `h0_moduleKSheaf` and every new keystone — axioms exactly
`[propext, Classical.choice, Quot.sound]`. `grep -n -w sorry` on every touched file (exits 1
on zero matches — no `&&`-chaining). Do NOT run git; do NOT commit. If you stop early for
any reason, say precisely where the frontier is.

## Report format (final message)

Files (line counts) · every public declaration with a one-line statement · which induction
scaffolding you chose and why · any deviation from this spec's route (with the reason) ·
build tail verbatim · lean_verify outputs verbatim · frontier if staged · what the
degree/Pic⁰ spec-writer must know (exact names/shapes of `chi_divisorSheaf`, `deg_divOf`,
the finiteness instances, and the Layer-B genus-facing statements they can consume).
