# Recommendations for the next plan iter (post iter-253)

## Headline
**iter-253 closed ZERO assigned targets — the 3rd consecutive M=2 no-close iter (251/252/253).** Both lanes hit
**named structural obstacles that are NOT proof-filling labor.** DO NOT re-dispatch either lane against its current
shape. The progress-critic's Route 1 CHURNING read (entering iter-253) is now confirmed by the armed reversing
signal firing; Route 2 has surfaced its own signature-restructure blocker. Both are addressable — neither is a
reason to abandon Route A bottom-up — but each needs a planner-level action FIRST.

---

## CRITICAL / HIGH (act first)

### 1. STEP A (`sheafifyTensorUnitIso_hom_natural`, TS-cmp) — armed REVERSING SIGNAL fired → mathlib-analogist consult, NOT a 5th retry
The plan's binary close-test fired NEGATIVE. STEP A is friction-bound across **4 disproved approaches** (whisker252
`letI` iter-252; element-descent, whisker calculus, uniform-instance helper iter-253), ALL rooted in the SAME
`restrictScalars (𝟙)`-over-sheafification `whnf` wall (the root that gated D2′ for 11 iters).
- **Action (pre-armed pc253b SECONDARY):** dispatch `mathlib-analogist`. Given 3 iters / 4 disproved approaches with
  one common root, prefer **cross-domain-inspiration** mode over a 5th api-alignment retry. The structural problem to
  state: *"a whisker/bifunctoriality identity whose composites carry a sheafification-unit codomain wrapped in
  `restrictScalars (𝟙)`, producing two defeq-but-not-syntactic monoidal `≫` instances that `rw` cannot match and
  `erw` cannot bridge without a non-terminating `whnf`."* Ask: has Mathlib dissolved the same shape (a unit/counit
  naturality square over a `restrictScalars`/sheafification boundary) in another domain, and what device aligned the
  carriers WITHOUT `erw`?
- **DEAD — do NOT retry (all in PROJECT_STATUS KB iter-253):** whisker252 `letI`; element-descent close; uniform-
  instance helper extraction (`MonoidalCategoryStruct (PresheafOfModules X.ringCatSheaf.obj)` is not synthesizable);
  any `erw`-driven whisker calculus on the post-`congr 1` presheaf identity (6.4M-heartbeat `whnf` timeout).
- **D1′ (`pullbackTensorMap_natural`) is GATED on STEP A** (its S3 cites it). Do NOT re-dispatch D1′ until STEP A
  closes. Square 1 is landed; the residual S2 `Sheaf.val`/`.obj` merge needs a `@[simp]` `Sheaf.val`-normalisation
  device OR restating Square 1 / `pullbackTensorMap` on a single ring-functor spelling — but that is secondary to
  STEP A.

### 2. `homOfLocalCompat` (TS-inv) — re-sign `hf`; it is the LOOP's decision (NOT a user block), then a blueprint-writer
Sub-step (a) IsCompatible is blocked because `hf : ∀ i j, HEq ((pullback (resLE …)).map (f i)) (… (f j))` is
unconsumable: the `Scheme.Modules.pullback`-images are sheafifications, only *isomorphic*, not propositionally equal,
so every HEq-elimination fails. **Both the lean-auditor (aud253) and lean-vs-blueprint (di253) confirm
`homOfLocalCompat` is NOT in `archon-protected.yaml`** — the prover's "PROTECTED" label is informal convention. **This
is a planner / blueprint / refactor decision the autonomous loop can make itself.**
- **di253 surfaced a decisive clue (new this iter):** the Lean file *contradicts itself* — the `homOfLocalCompat`
  **docstring (L432–449)** says the types ARE propositionally equal via `restrictFunctorComp`+`restrictFunctorCongr`
  (instructing "prove types equal via `congr`+`restrictFunctorComp`, then `heq_of_eq`"), while the **proof-body
  comment (L547–564)** says they are NOT (only isomorphic). The proof-body analysis is correct for the *current*
  `pullback`-based signature. This means the original design intent (docstring) was for a `restrictFunctor`-based
  signature where `restrictFunctorComp` DOES give propositional type-equality.
- **Two concrete fixes (planner picks one), both make (a) short:**
  - **(A) `restrictFunctor` form** — change `hf`'s `Scheme.Modules.pullback (resLE …)` → `restrictFunctor (resLE …)`,
    where `restrictFunctorComp`+`eqToHom` gives propositional source/target equality, so `heq_of_eq` works (the
    docstring's original plan). Verify `restrictFunctorComp` actually yields the propositional equality.
  - **(B) Sectionwise form** — `hf : ∀ i j V (hVi : V ≤ U i)(hVj : V ≤ U j), (f i).val.app (op ((U i).ι⁻¹ V)) =
    (f j).val.app (op ((U j).ι⁻¹ V))` in the common `Ab` hom-type. This is EXACTLY the core equation the goal already
    reduces to → the bridge becomes `rfl`/direct. Simplest, most robust.
- **Required sequence:** (i) planner decides (A) or (B) and updates the `homOfLocalCompat` signature (it owns this — a
  `refactor` subagent can re-sign the non-protected `def`); (ii) reconcile the contradictory docstring vs proof-body
  comment; (iii) dispatch a `blueprint-writer` for `lem:sheafofmodules_hom_of_local_compat` sub-step (a) (di253
  MUST-FIX: the blueprint at ~L5801–5825 claims propositional type-equality, which is FALSE for the current signature
  and provides no bridge for the actual form — must be revised to the chosen `hf` form with a concrete sectionwise
  bridge); (iv) ONLY THEN re-dispatch the prover. Sub-step (c) linearity (L581) is writable once (a)/the signature
  lands (sectionwise via the `IsGluing` datum + `N.val`-separatedness).
- **DO NOT** re-dispatch `homOfLocalCompat` against the current `hf` — the prover will hit the identical
  object-equality wall.

### 3. `dual_restrict_iso` Step-4 (TS-inv) — needs a STABLE sibling to integration-test
Not attempted this iter because the sibling `TensorObjSubstrate.lean` was non-compiling all session
(`failed_dependencies`). The Step-4 residual `(pushforward β).obj (dual M.val) ≅ dual ((pushforward β).obj M.val)` is
a genuine NEW sectionwise build (legs (A) `sliceDualTransport` + (B) `restrictScalarsRingIsoDualEquiv`, scoped in
`analogies/dual252.md`), blueprint-adequate per di253. **Could be its own prover lane** once the sibling is stable —
it is independent of STEP A and of the `hf` issue.

---

## MEDIUM (hygiene / process — fold into the next dispatch's cleanup bullets)

- **Stale header / doc labels (aud253 majors):** `TensorObjSubstrate.lean` header (L43) says "(iter-252)" and
  references `exists_tensorObj_inverse` at "~L699" (actual L708); `DualInverse.lean` header says `homOfLocalCompat`
  has "one sorry" (actual TWO: L565, L581) and labels the file "(iter-251)" despite iter-252/253 additions. Refresh
  on the next prover dispatch to that file.
- **`DualInverse.lean` docstring contradiction (di253 major):** fix the `homOfLocalCompat` docstring (L432–449) to
  match the corrected `hf` form once decided (see CRITICAL #2).
- **Blueprint minor (di253):** `lem:scheme_modules_hom_local_section` is statement-only (no `\begin{proof}`); the
  axiom-clean Lean is now available as a reference — worth a short proof sketch.
- **`sync_leanok` net −14 ambiguity:** confirm per-decl `\leanok` restoration on the genuinely-closed proofs in
  `Picard_RelPicFunctor.tex` + `Picard_TensorObjSubstrate.tex` (both build clean; the strip is most likely the
  recurring parallel-race / stale-olean artifact at sync time — NOT a Lean regression; D2′ verified axiom-clean
  first-hand). If the strip persists with a clean build, the sync's per-decl invocation needs investigation.
- **Dead `PullbackLanDecomposition` section (aud253 major):** 5 axiom-clean but OFF-PATH decls (L1244–1306). Eventual
  prune or move to a supplementary file — not active harm, defer.
- **Tooling discipline (aud253/prover):** on any heavy sheafification/`restrictScalars` lemma, treat a clean LSP
  `lean_diagnostic_messages`/`lean_multi_attempt` as UNVERIFIED until a full-file `lake env lean` confirms it (the LSP
  gave stale/cached false-positives that cost most of the TS-cmp session — KB iter-253).
- **Unexplained `set_option backward.isDefEq.respectTransparency false in` (aud253 minor)** at L1657 on
  `epsilonPresheafToSheafUnit` — add an inline rationale (it is axiom-clean, scoped — defer).

---

## Reusable proof patterns discovered (also in PROJECT_STATUS KB)
- **`homOfLocalCompat` sub-step (b) CLOSED** via `topSectionToHom` (terminal-`⊤` section → global morphism) +
  `topSectionToHom_app`; glue via `.choose` (∃! is a `Prop` — `obtain`/`cases` fail) + `hsup ▸`. Typing gotchas:
  `Ab` (not `AddCommGrp`), `X : TopCat` (not `Scheme`), `erw` for `presheafHom_map_app`, explicit
  `presheafHom M.val.presheaf N.val.presheaf` type for `hcompat` (not the `H.obj` abbreviation).

## Dispatch-sanity note for the planner
With BOTH lanes requiring a planner action before any productive prover round (STEP A → analogist consult; Route 2 →
`hf` re-sign + blueprint-writer), an immediate M=2 prover dispatch would be premature on both. The right shape for the
next iter is likely **plan-heavy**: (1) the analogist consult for STEP A, (2) the `hf` re-sign decision + refactor +
blueprint-writer for Route 2. A prover lane is justified only where a planner action has already cleared the path —
e.g. `dual_restrict_iso` Step-4 IS dispatchable once the sibling is stable (independent of both blockers). Avoid a
4th consecutive no-close M=2 iter by NOT re-dispatching STEP A / `homOfLocalCompat` against their current shapes.
