# Strategy Critic Directive

## Slug
pivot

## Project goal

Prove `AlgebraicGeometry.cech_computes_higherDirectImage` (protected, frozen signature): for `f : X ⟶ S` separated and quasi-compact, `F` quasi-coherent, and `𝒰` a finite affine open cover of `X`, the existence-form isomorphism `Nonempty ((CechComplex f 𝒰 F).homology i ≅ higherDirectImage f i F)` (under `[HasInjectiveResolutions X.Modules]`), where `higherDirectImage f i F = ((pushforward f).rightDerived i).obj F`. End-state: zero inline `sorry` in the cone, zero project axioms, kernel-only axioms. The downstream Picard/Quot machinery is out of scope (carved away in the extraction).

## Strategy under review

# Strategy

## Goal

Prove `AlgebraicGeometry.cech_computes_higherDirectImage` (`lem:cech_computes_cohomology`),
the protected, frozen-signature target: for `f : X ⟶ S` separated and quasi-compact, `F`
quasi-coherent, and `𝒰` a finite affine open cover of `X`, an isomorphism in the weak
existence form `Nonempty ((CechComplex f 𝒰 F).homology i ≅ higherDirectImage f i F)` (under
`[HasInjectiveResolutions X.Modules]`), where `higherDirectImage f i F =
((pushforward f).rightDerived i).obj F`. End-state: zero inline `sorry` in the cone, zero
project axioms, kernel-only axioms. Extraction from the Algebraic-Jacobian challenge; the
downstream Picard/Quot machinery is out of scope and was carved away.

## Phases & estimations

| Phase | Status | Iters left | LOC | Key Mathlib needs | Risks |
|---|---|---|---|---|---|
| P3 affine acyclicity (`CechAcyclic.affine`) — the long pole | ACTIVE (statement-gap fix first) | ~4–7 | ~250–550 | from-scratch: standard-cover Čech complex = complex of localisations; prime-local contracting homotopy `h(s)_{i₀…iₚ}=s_{i_fix i₀…iₚ}`; `isZero` via localise-at-prime. Mathlib LACKS all of these for `Scheme.Modules` (leansearch confirms only generic `Acyclic`/`ExactAt`). | Statement gap (Open Q): blueprint proves STANDARD-cover; Lean sig takes general `X.OpenCover`. DECIDED: narrow non-protected signature to standard covers (downstream-safe via P5a basis lemma). Needs a "standard affine cover" Lean type (design — analogist consult). Then build localisation Čech + homotopy from scratch. Every geometric node routes through this except `lem:higher_direct_image_presheaf`. |
| P5a vanishing inputs (mostly P3-dependent; one P3-independent leaf) | NEXT | ~3–6 | ~250–550 | augmented-Čech-is-a-resolution (`cechAugmented_exact`); presheaf description `R^if_*=sheafify(V↦H^i(f⁻¹V))` (`higher_direct_image_presheaf`, Stacks 01XJ); basis lemma `lem:cech_to_cohomology_on_basis`; affine Serre vanishing | All P5a decls ABSENT from Lean (scaffold first). `lem:higher_direct_image_presheaf` is the lone P3-independent leaf, BUT itself needs the rightDerived↔sheafified-presheaf-cohomology comparison for `Scheme.Modules` — Mathlib's version is `Sheaf J AddCommGrpCat`, wrong category, so also from-scratch. `cechAugmented_exact`/basis/serre all consume narrowed-P3. Statement↔proof parity on basis lemma still open (iter-009 writer note). |
| P5b comparison assembly | LAST (needs P3, P4, P5a) | ~2–4 | ~150–300 | P3 + P4 + P5a + termwise `f_*`-acyclicity of `Cᵖ` (relative affine vanishing after localising to affine `S`) | Final assembly of `cech_computes_higherDirectImage` (protected, frozen sig+path) from the resolution (P5a), termwise acyclicity (`cechTerm_pushforward_acyclic` via P3 + relative reduction), and the P4 acyclic-resolution comparison (now an off-the-shelf engine). Routes the general finite-affine `𝒰` through the basis lemma, NOT `CechAcyclic.affine` directly. Lean proof comment still describes the OLD spectral-sequence route — clean during a refactor. |

## Completed

| Phase | Iters (done@ · used) | LOC | Files | Key results | Reusable techniques | Pitfalls |
|---|---|---|---|---|---|---|
| P1 push–pull functor laws | 002 · 2 | ~120 | `CechHigherDirectImage.lean` | `pushPullMap_comp` (composition law) closing the push–pull functoriality cone | object-form alignment `simp only [Functor.comp_obj]` BEFORE `reassoc_of%`; `rawPushPullMap` + `subst`-the-over-triangles + pentagon, sidestepping `conjugateEquiv` | the `conjugateEquiv_comp` mate route is INFEASIBLE (kernel `whnf` blow-up); do not retry it |
| P2 `CechNerve`/`CechComplex` | 002 · 1 (stretch) | ~60 | `CechHigherDirectImage.lean` | `pushPullFunctor` (G), `coverCechNerveOver(Aug)`, `CechNerve`, `CechComplex` all axiom-clean | once `G` is a functor: `Over.lift` + `.rightOp` + `CosimplicialObject.Augmented.whiskeringObj`; terminal-object augmentation (`Over.mkIdTerminal`) makes coherence automatic | none — clean off-the-shelf transport |
| P4 abstract acyclic-resolution lemma (Leray's acyclicity, Stacks 015E) | 009 · 6 (004–009) | ~965 (file) | `AcyclicResolution.lean` | `rightDerivedIsoOfAcyclicResolution` (RⁿG ≅ Hⁿ(G K•) for a G-acyclic resolution), `rightDerivedOneIsoCokerOfAcyclic`, horseshoe `ofShortExact`, object-level dimension shift, cosyzygy layer — all axiom-clean | decompose-then-build cadence (effort-break → frontier-leaf → assembly); two-step `cokernel.mapIso` for non-syntactic homology naturality; `isLimitForkMapOfIsLimit'`+`conePointUniqueUpToIso` for left-exact transport; `Nat.rec` staircase off a generalized `stairGen` | `ShortComplex.mapCyclesIso` is WRONG for a left-exact functor (needs preserve-colimit); `← G.map_comp` silently fails beside a mapped-complex term (isolate in a clean `have`, term mode) |

## Routes

### Route A — acyclic-resolution comparison (CHOSEN)
The augmented Čech complex `0 → F → C⁰ → C¹ → ⋯` on `X` (`Cᵖ = ∏ (j_s)_*(F|_{U_s})` over
`(p+1)`-fold intersections) is (i) a resolution of `F` and (ii) termwise `(pushforward f)`-
acyclic, because each intersection is affine (relative Serre vanishing, P3). The abstract
homological-algebra theorem "a `G`-acyclic resolution computes `G.rightDerived`" (P4, built
by dimension-shifting from Mathlib's `InjectiveResolution.isoRightDerivedObj`) then gives
`Hⁱ(f_* C•) = Hⁱ(CechComplex) ≅ (pushforward f).rightDerived i F` directly — ONE abstract
lemma, NO spectral sequences. This is the standard Cartan–Leray acyclic-cover proof of the
existence statement; it folds P3 in as its acyclicity input.

### Route B — two spectral sequences (REJECTED, fallback only)
The literal Stacks 02KE route: a Čech-to-derived spectral sequence plus the Leray spectral
sequence for `Scheme.Modules`. Rejected: both spectral sequences are absent from Mathlib
(multi-thousand-LOC to build), and the Leray degeneration additionally needs quasi-coherence
of `R^q f_* F` (`lemma-quasi-coherence-higher-direct-images`, itself non-trivial via relative
Mayer–Vietoris). Strictly heavier than Route A for the same `Nonempty (… ≅ …)` goal. Kept on
record only as a fallback if Route A's abstract lemma proves unexpectedly hard.

### The P3-narrowing ↔ P5a-basis-lemma bridge (load-bearing)
Narrowing the non-protected `CechAcyclic.affine` signature to STANDARD covers is
downstream-safe **only** because the final assembly (P5b) does not apply `CechAcyclic.affine`
to the general finite-affine `𝒰` directly. Instead, the general-cover intersection vanishing
`H^q(U_σ, F) = 0` is obtained from narrowed standard-cover acyclicity through the basis lemma
`lem:cech_to_cohomology_on_basis` (Stacks 01EO): standard affine covers `D(f_i)` form a basis,
and 01EO lifts Čech-acyclicity on a basis to sheaf-cohomology vanishing on every affine open.
Hence the basis lemma (scoped in P5a) is the linchpin connecting narrowed P3 to the general
`𝒰` in the frozen goal; "downstream-safe" is a *derived* claim contingent on building it.
The project does NOT formalize the full Stacks-01EO bootstrap: it only needs the affine /
standard-cover special case, proved directly via the P4 acyclic-resolution theorem applied to
the augmented Čech complex with `G = Γ(B,-)` (term-acyclicity from the P3 contracting homotopy).
See Open strategic questions for the enumerated reduction.

## Open strategic questions

- P5a basis lemma `lem:cech_to_cohomology_on_basis`: RESOLVED scoping (iter-009). Mathlib's
  site cohomology (`Sites/SheafCohomology/*`) is `Sheaf J AddCommGrpCat`, the WRONG category
  (not `O_X`-modules) — not directly reusable. DECIDED route: do NOT formalize the general
  Stacks-01EO bootstrap. The project only ever applies the basis lemma to AFFINE opens
  with STANDARD covers, where the reduced-scope rewrite proves it directly: apply
  `lem:acyclic_resolution_computes_derived` with `G = Γ(B,-)` to the augmented Čech complex of a
  standard cover, term-acyclicity from the same prime-local contracting homotopy as
  `lem:cech_acyclic_affine`. So the basis lemma `\uses{lem:cech_acyclic_affine,
  lem:acyclic_resolution_computes_derived}` — it consumes narrowed P3 (non-circular).
- P3 statement gap: narrow `CechAcyclic.affine` to a standard-cover hypothesis (DECIDED). Open
  sub-question: the precise "standard affine cover" Lean type (non-trivial design); resolve in
  the P3 refactor before the effort-break.
- P3: exact Mathlib names for prime-local exactness; verify before dispatching.
- P5b: termwise `(pushforward f)`-acyclicity reduces to affine Serre vanishing via Stacks
  `lemma-relative-affine-vanishing` after localising to affine `S` (resolved).
- P5a/P5b blueprint Route-A-clean rewrite: DONE iter-009. Pending: fresh whole-blueprint gate
  review (this iter); statement↔proof parity on `lem:cech_to_cohomology_on_basis`.
- File-split for parallelism: all P5 decls are absent from Lean and live under ONE consolidated
  chapter / one file, so they cannot be parallel prover lanes as-is. DECIDE the multi-file
  decomposition and scaffold each into its own file under the same `AlgebraicGeometry` namespace +
  the consolidated chapter's `% archon:covers`. Keep `cech_computes_higherDirectImage` sig+path frozen.

## Mathlib gaps & new material

Gaps to fill (project-side, Mathlib lacks):
- Standard-cover Čech complex as the complex of localisations + its prime-local contracting
  homotopy / positive-degree exactness (P3).
- Relative affine vanishing `R^i(affine morphism)_* = 0 (i>0)` and `R^q(jₛ)_* = 0` for affine
  open immersions into separated `X`, for `Scheme.Modules` (P5b termwise acyclicity / P5a).
- Flat pushforward preserves injective `O_X`-modules — backs the SS-free open-immersion rewrite.
- Augmented Čech complex is a resolution (stalkwise exactness) for `Scheme.Modules` (P5a).
- Čech-to-cohomology-on-a-basis (P5a) — NOT atomic. Project-only special case reduces to
  `lem:cech_acyclic_affine` + the P4 acyclic-resolution theorem with `G = Γ(B,-)`.

New project material:
- push–pull functor `G : (Over X)ᵒᵖ ⥤ X.Modules`, `p ↦ p_* p^* F` — keep hand-rolled.
- `CechNerve` / `CechComplex` / `CechAcyclic.affine`.
- `AcyclicResolution.lean`: abstract acyclic-resolution comparison.
- comparison assembly `cech_computes_higherDirectImage` via Route A.

## References index

This subproject was extracted from the Algebraic-Jacobian challenge; only the Čech-cohomology source is retained.

| File | Description |
| ---- | ----------- |
| `stacks-coherent.md` → `stacks-coherent.tex` | Stacks ch.30 "Cohomology of Schemes". Tags 02KE (`lemma-cech-cohomology-quasi-coherent`), `lemma-cech-cohomology-quasi-coherent-trivial` (standard-cover Čech vanishing), 02KG (`lemma-quasi-coherent-affine-cohomology-zero`, Serre vanishing on affines), `lemma-quasi-coherence-higher-direct-images-application` (H^q(X,F)=H^0(S,R^q f_* F) for affine S), `lemma-relative-affine-vanishing`. |
| `homological-acyclic.md` → `homological-acyclic-derived.tex`, `homological-acyclic-homology.tex` | Stacks `derived.tex`+`homology.tex` — right-F-acyclic objects (0157), vanishing criterion (015C), Leray's acyclicity lemma (015E: an F-acyclic resolution computes RF), enough acyclics (05TA). Backs `Cohomology_AcyclicResolution.tex` (P4, DONE). |
| `stacks-cohomology.md` → `stacks-cohomology.tex` | Stacks ch. "Cohomology" — `lemma-describe-higher-direct-images` (01XJ: R^i f_* F = sheafify of V↦H^i(f⁻¹V,F)); `lemma-cech-vanish-basis` (01EO: Čech-to-cohomology comparison on a basis). Backs `Cohomology_CechHigherDirectImage.tex`. |

## Blueprint summary

- `Cohomology_AcyclicResolution.tex` — abstract homological algebra: a G-acyclic resolution computes G.rightDerived (Leray's acyclicity, Stacks 015E). P4, CLOSED (both targets proven, axiom-clean).
- `Cohomology_CechHigherDirectImage.tex` — consolidated chapter: the Route-A Čech computation of R^i f_*. Push-pull functor G (done), Čech nerve/complex (done), standard-cover affine acyclicity `CechAcyclic.affine` (P3, sorry), Serre affine vanishing, basis-comparison lemma, augmented-complex-is-a-resolution, presheaf description of R^i f_* (Stacks 01XJ), affine-open-immersion pushforward acyclicity, each-Čech-term f_*-acyclicity, and the protected comparison theorem `cech_computes_higherDirectImage` (P5b, sorry). All P5 decls absent from Lean (scaffold).
- `Cohomology_HigherDirectImage.tex` — thin: the derived-functor definition of R^i f_* as the i-th right derived functor of f_* (the object the Čech construction compares against). Done.

## Prior critique status

- iter-009: P5a basis-lemma effort honesty (under-scoped, atomic-treatment of a non-atomic general-01EO lemma) — addressed (reduced-scope route committed; bridge confirmed non-circular).
- iter-009: Route A genuinely SS-free for all three suspect P5 lemmas — addressed (blueprint-writer de-spectral-sequenced the three blocks; pending fresh gate review this iter).
