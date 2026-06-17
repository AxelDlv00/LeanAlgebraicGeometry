# Blueprint Review Report

## Slug
iter116

## Iteration
116

## Top-level summaries

### Incomplete parts
- `Differentials.tex` / L59 + L73 — two Mathlib name slips that the iter-115 reviewer flagged and that the iter-116 plan agent has dispatched a parallel blueprint-writer to fix. These are *currently present in the chapter as audited*:
  - L59 `\texttt{KaehlerDifferential.isLocalizedModule\_map}` — verified via `lean_loogle`: only `KaehlerDifferential.isLocalizedModule` (no `_map` suffix) exists in Mathlib at module `Mathlib.RingTheory.Kaehler.TensorProduct`.
  - L73 `\texttt{AlgebraicGeometry.Modules.tilde}` — verified via `lean_loogle`: correct namespace is `AlgebraicGeometry.tilde` (in `Mathlib.AlgebraicGeometry.Modules.Tilde`).
  - **Known-pending.** A blueprint-writer is being dispatched in parallel this iter; this audit may pre-date that fix. The iter-117 reviewer dispatch will confirm closure.
- `Differentials.tex` § "Unique-gluing form" Step 2 — the cofinality descent is honestly flagged as `[gap]` at L112–L119 ("No off-the-shelf Mathlib lemma packages …"); the chapter does NOT pretend a Mathlib bridge exists. The pause on the corresponding Lean target (L175 / post-edit L191) is the iter-116 user-escalation matter, not a blueprint defect.

### Proofs lacking detail
- None this iter. Every theorem/lemma block whose `\leanok` marker is present has either a detailed proof sketch tied to named Mathlib lemmas, or an explicit honest-disclosure `[gap]` / "named-deferred Mathlib gap" annotation. The iter-114 unique-gluing recipe in `Differentials.tex` remains the recipe of record; the iter-115 PASS verdict on that recipe still holds.

### Lean difficulty quality
- `Differentials.tex` / `\lean{AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf_isSheafUniqueGluing_type}` — target is well-formulated mathematically (unique-gluing characterisation of a Mathlib-shaped sheaf condition) but is currently **paused on user-escalation** per `USER_HINTS.md`. The blueprint chapter's framing of the recipe is fine; the question is strategic, not a blueprint quality issue.
- All other `\lean{...}` hints across the 13 chapters are well-formed: each points to a concrete declaration with a discoverable signature, and the surrounding prose pins down argument shape (or the chapter says "named-deferred Mathlib gap" explicitly).

### Multi-route coverage
- **Single route** (per directive). The strategy explicitly notes alternate routes (full Hilbert/Quot; Sym^g / S_g quotient; divisor-class image Pic⁰) but does NOT select them. The JacobianWitness exit policy + named-gap framing is the only blueprint-supported route, and it is covered by `Jacobian.tex` § "Existence of an Albanese variety" + `AbelJacobi.tex` § "Implementation route via the Albanese framework". PASS.

## Per-chapter

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `\thm:exists_unique_ofCurve_comp` cleanly cites `\thm:nonempty_jacobianWitness` and `\def:IsAlbanese`; the implementation-route disclosure of the Pic-scheme deferral is precise.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - L1198 § "Implementation status (iter-108 escape-valve)" enumerates the named-deferral surface with **multiple stale line references** that have drifted since iter-112:
    - `\texttt{Differentials.lean:636}` for `cotangentExactSeq_structure.h_exact` → actual current line is **L737** (declaration); the inline `case h_exact` token is also no longer at L636.
    - `\texttt{Differentials.lean:877}` for `serre_duality_genus` → actual current line is **L1091** (declaration).
    - `\texttt{Jacobian.lean:179}` for `nonempty_jacobianWitness` → actual current line is **L176** (declaration).
    - `\texttt{Picard/Functor.lean:181}` for `PicardFunctor.representable` → actual current line is **L176** (declaration).
    - `\texttt{Modules/Monoidal.lean:173}` for `instIsMonoidal_W` → declaration is at L166, the inline `sorry` token is at L173. Both citation conventions appear in the project; not strictly stale.
  - **Severity: non-blocking** — file is `BasicOpenCech.lean`-oriented and the entire Phase A residual surface is off-limits this iter (L1120 PAUSED; L1212/L1536/L1564 substep-deferred; L1754 gated; L1846 budget-deferred). The stale references do not feed a prover-active chapter.
  - The narrative recipe (Step 1–4 at L1162–L1183) for `\thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf` is detailed and matches the Lean inline scaffolding at L1781–L1846 of `BasicOpenCech.lean`.

### blueprint/src/chapters/Cohomology_SheafCompose.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 40-line chapter; the single theorem `\thm:HasSheafCompose_forget` is fully proven by limit-preservation composition.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - The three Phase-A step-2/3/4 instances (`HasSheafify_Opens_AddCommGrp`, `HasExt_Sheaf_Opens_AddCommGrp`, `Scheme.toAbSheaf`) tie cleanly together with universe-pinning prose.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: true
- **correct**: true
- **notes**:
  - 655-line chapter; thorough. The `k`-module-flavoured sheaf-cohomology pipeline (sheafification → Ext → `HModule` → `HModule'`) chains correctly; the producer/consumer carrier instances (`IsAffineHModuleVanishing`, `IsAffineHModuleHomFinite`, `IsHModuleHomFinite`) compose cleanly; the Stein-finiteness chain to `instIsHModuleHomFinite_toModuleKSheaf` is well-detailed.

### blueprint/src/chapters/Differentials.tex
- **complete**: partial
- **correct**: partial
- **notes**:
  - **L59** `\texttt{KaehlerDifferential.isLocalizedModule\_map}` → drop `_map`. Verified.
  - **L73** `\texttt{AlgebraicGeometry.Modules.tilde}` → should be `AlgebraicGeometry.tilde`. Verified.
  - Both fixes are in flight via parallel blueprint-writer dispatch this iter (per directive). Re-audit at iter-117 mandatory dispatch.
  - **L112–L119** § "Unique-gluing form" Step 2 — explicit `[gap]` annotation. Honest and correct framing of the missing Mathlib bridge; this is the iter-116 user-escalation blocker on L175 (post-edit L191) `relativeDifferentialsPresheaf_isSheafUniqueGluing_type`.
  - **L168** `\def:relative_kaehler_sheaf` — "morally quasi-coherent (the presheaf is locally a Mathlib `KaehlerDifferential` module), but the Lean object does not currently carry the `IsQuasicoherent` typeclass on the sheaf". The iter-115 reviewer flagged this as a soft remnant; it is still present. **Soft, non-blocking** — the disclosure is mathematically accurate, but consider tightening to "the Lean object is quasi-coherent on each affine chart by construction; the `IsQuasicoherent` typeclass on the assembled sheaf is not yet registered" in a future writer pass.
  - **L335** `\thm:serre_duality_genus` — uses `IsIntegral` + `Smooth` hypothesis. ✓ Matches Lean signature; the iter-115 reviewer flagged this as resolved, and it remains resolved.

### blueprint/src/chapters/Genus.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Definition + remark match the Lean `noncomputable def genus` body; user-authorisation paragraph for `noncomputable` is in place.

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Albanese framework is the strategy's selected route; the bundle-into-`nonempty_jacobianWitness` hypothesis is honest and complete. The genus-0 rigidity content is correctly absorbed into the witness's universal property.

### blueprint/src/chapters/Modules_Monoidal.tex
- **complete**: true
- **correct**: true
- **notes**:
  - The "Honest disclosure: $W$.IsMonoidal is load-bearing post-C1" remark (L64–L72) is precise. The §"Formalization status" enumeration at L143–L150 matches the actual `AlgebraicJacobian/Modules/Monoidal.lean` state.

### blueprint/src/chapters/Picard_Functor.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - **L88** `\texttt{Picard/LineBundle.lean:93,\,82}` — `93` is **stale**; `pullback_oneIso` lives at L96 of `AlgebraicJacobian/Picard/LineBundle.lean` (verified). Should read `LineBundle.lean:96,\,82` or `LineBundle.lean:82,\,96`. **Non-blocking** (consumer of this gap is `PicardFunctor.representable`, named gap #4, deferred via JacobianWitness exit policy — no prover dispatched).
  - **L10** and **L85** reference `Modules/Monoidal.lean:166` (declaration line of `instIsMonoidal_W`). Correct under the "declaration-line" citation convention; not stale.
  - The post-C1 dependency note at L77–L88 accurately walks the transitive `sorryAx` chain through `Pic.pullback` → the two named-deferred isos → `instIsMonoidal_W`.

### blueprint/src/chapters/Picard_FunctorAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - The post-iter-109 universe-bump simplification is well-disclosed.

### blueprint/src/chapters/Picard_LineBundle.tex
- **complete**: true
- **correct**: true
- **notes**:
  - The split-pair narrative for the named-deferred `pullback_tensorObj` (μ-iso) + `pullback_oneIso` (ε-iso) is precise and matches the Lean file structure at `Picard/LineBundle.lean:82,96`.
  - **L25** `Modules/Monoidal.lean:166` reference is correct (declaration line).

### blueprint/src/chapters/Rigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Self-contained helper chapter, file currently 0 sorries (per directive). The proof sketch + Mathlib-ingredients enumeration is adequate for a prover.

## Cross-chapter notes

- **Line-reference drift in the named-deferral inventory.** The detailed enumeration of the project's named-Mathlib-gap surface lives in `Cohomology_MayerVietoris.tex:1198` (the "iter-108 escape-valve status" paragraph). The line references it cites for `cotangentExactSeq_structure.h_exact`, `serre_duality_genus`, `nonempty_jacobianWitness`, and `PicardFunctor.representable` have all drifted since iter-112 (off by 60–250 lines each, in the direction of growth). This is a single locus of staleness — fixing it once in the MV chapter cleans the entire inventory. Non-blocking for this iter (BasicOpenCech.lean is off-limits) but worth a writer touch in iter-117+ if a Phase-A-resume happens.
- **`Picard_Functor.tex:88` line slip** (`LineBundle.lean:93` → `:96`) is a sister of the above drift. Same writer pass would fix it.
- **`Differentials.lean` itself uses both `KaehlerDifferential.isLocalizedModule` and `KaehlerDifferential.isLocalizedModule_map` in its inline narrative comments** (L71–L72 explicitly says "`KaehlerDifferential.isLocalizedModule` (and the scheme variant `KaehlerDifferential.isLocalizedModule_map`)"). The "scheme variant" is the comment's framing — but `lean_loogle` finds no `_map` variant in Mathlib. The blueprint's L59 cite of `isLocalizedModule_map` therefore propagates a misnaming that originated in the Lean comment. The parallel writer should fix L59 of the blueprint *and* the comments in `Differentials.lean` (L72, L112, L246) — but the latter is outside the writer's blueprint-only write domain, so it must be flagged to a future doctor/refactor pass instead.

## Strategy-modifying findings

None this iter. The iter-116 user escalation on the L175 unique-gluing route is a strategic decision for the user (Option 1 bridge / Option 2 refactor / Option 3 named-gap #8), but it is already disclosed correctly in `USER_HINTS.md` and the blueprint's Step 2 `[gap]` annotation reflects it honestly. The blueprint does not need a strategy-modifying edit to support any of the three options:

- **Option 1 (build the bridge)**: `Differentials.tex` § "Unique-gluing form" already names the bridge target ("`Scheme.PresheafOfModules`-sheaf-on-affine-basis ⇒ sheaf on $X$") — a future blueprint-writer would expand Step 2 from `[gap]` to a multi-page recipe, but no current claim becomes false.
- **Option 2 (refactor to presheaf-only)**: `Differentials.tex` § "Universal property and the cotangent exact sequence" and § "Smoothness and local freeness of $\Omega$" would need to relabel `\Omega_{X/S}` as a presheaf in the relevant downstream consumers; this is a writer task in iter-117+, not a strategy change at the blueprint level.
- **Option 3 (named gap #8)**: `Cohomology_MayerVietoris.tex:1198` would gain an 8th entry in the named-deferral list; trivial writer edit.

## Severity summary

- **must-fix-this-iter**:
  - `Differentials.tex` `complete: partial / correct: partial` due to the L59 + L73 Mathlib name slips. *Already being handled* by the parallel blueprint-writer dispatch this iter. If the writer lands its fix before iter-117 plan-phase, the hard gate on `Differentials.lean` will lift; otherwise the iter-117 mandatory me-dispatch will re-confirm.
- **soon**:
  - `Cohomology_MayerVietoris.tex:1198` named-deferral inventory line-reference drift (4 stale refs). Non-blocking, but accumulates if Phase A resumes; bundle into the next MV chapter writer pass.
  - `Picard_Functor.tex:88` `LineBundle.lean:93` → `:96` slip. Same pass.
  - `Differentials.tex:168` "morally quasi-coherent" remnant — soft prose, consider tightening on the same pass as the L59+L73 fix.
- **informational**:
  - The "scheme variant `KaehlerDifferential.isLocalizedModule_map`" framing inside `Differentials.lean` (L72, L112, L246) propagates a Mathlib misnaming. Flag for a future doctor/refactor pass; outside the iter-116 blueprint-writer write domain.

### Hard gate per-file verdict (for iter-117+ prover dispatch decisions)

| File | Chapter | iter-117+ prover dispatch eligible? | Why |
|------|---------|-------------------------------------|-----|
| `AlgebraicJacobian/AbelJacobi.lean` | `AbelJacobi.tex` | YES (blocked on content, not blueprint) | complete: true / correct: true; 0 sorries; blocked downstream on `instIsMonoidal_W` + Phase C3. |
| `AlgebraicJacobian/Cohomology/MayerVietorisCore.lean` + `MayerVietorisCover.lean` | `Cohomology_MayerVietoris.tex` | YES (no sorries) | complete: true / correct: partial; the partial correctness is line-ref drift in §"iter-108 escape-valve status", which is BasicOpenCech-oriented and does not feed these files. |
| `AlgebraicJacobian/Cohomology/SheafCompose.lean` | `Cohomology_SheafCompose.tex` | YES (no sorries) | complete: true / correct: true. |
| `AlgebraicJacobian/Cohomology/StructureSheafAb.lean` | `Cohomology_StructureSheafAb.tex` | YES (no sorries) | complete: true / correct: true. |
| `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean` | `Cohomology_StructureSheafModuleK.tex` | YES (no sorries) | complete: true / correct: true. |
| `AlgebraicJacobian/Cohomology/BasicOpenCech.lean` | (MV chapter §"escape-valve status") | OFF-LIMITS per directive (Phase A paused) | unaffected by my verdict; six labelled sorries are paused/deferred. |
| `AlgebraicJacobian/Differentials.lean` | `Differentials.tex` | **NO — DEFER** | complete: partial / correct: partial (L59 + L73 name slips, must-fix). Parallel writer should fix this iter; if so, iter-117 reviewer green-lights. Independently, the L175 route is paused on user escalation regardless of blueprint state. |
| `AlgebraicJacobian/Genus.lean` | `Genus.tex` | YES (no sorries) | complete: true / correct: true. |
| `AlgebraicJacobian/Jacobian.lean` | `Jacobian.tex` | named gap #3 only — no prover work | complete: true / correct: true; lone sorry is deferred. |
| `AlgebraicJacobian/Modules/Monoidal.lean` | `Modules_Monoidal.tex` | named gap #1 only — no prover work | complete: true / correct: true; lone sorry is deferred. |
| `AlgebraicJacobian/Picard/Functor.lean` | `Picard_Functor.tex` | named gap #4 only — no prover work | complete: true / correct: partial (L88 line-ref slip). Lone sorry is deferred; the slip is in prose adjacent to it and doesn't gate any prover dispatch. |
| `AlgebraicJacobian/Picard/FunctorAb.lean` | `Picard_FunctorAb.tex` | YES (no sorries) | complete: true / correct: true. |
| `AlgebraicJacobian/Picard/LineBundle.lean` | `Picard_LineBundle.tex` | named gaps #5/#6 only — no prover work | complete: true / correct: true; both sorries are deferred. |
| `AlgebraicJacobian/Rigidity.lean` | `Rigidity.tex` | YES (no sorries) | complete: true / correct: true. |

**Net iter-117 prover-dispatch implication**: The only file whose blueprint-side hard gate would fire is `Differentials.lean`, and only on the cosmetic-name-slip axis (L59 + L73). The parallel blueprint-writer dispatched this iter should close that. Independent of the gate, every Phase B prover-viable target on `Differentials.lean` (L880 `smooth_iff_locally_free_omega`, L947 `cotangent_at_section`) is still downstream of the L175/L191 user-escalation decision, so even with the gate lifted no prover would be dispatched on `Differentials.lean` until the user response lands.

## Overall verdict

PASS-WITH-MINOR-FIXES. 13 chapters audited; 1 chapter `complete: partial / correct: partial` (Differentials.tex, with the iter-116 parallel writer dispatch already in flight to close it); 2 chapters `correct: partial` on cosmetic line-reference drift (Cohomology_MayerVietoris.tex, Picard_Functor.tex), non-blocking; 0 strategy-modifying findings; multi-route coverage PASS (single route). The blueprint is in a healthy state for the iter-117 plan phase once the parallel `Differentials.tex` writer lands.
