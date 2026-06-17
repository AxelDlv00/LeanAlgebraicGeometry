# Picard/TensorObjSubstrate.lean — fine-grained pass (iter-271)

Objective 2: close `sheafificationCompPullback_comp_tail` R1/R5 recovery (sorry ~L2664)
via the analogist's `conjugateEquiv_whiskerRight` route (`analogies/d3-mate271.md`).

The tail's remaining residual is a single deep two-layer mate-calculus sorry (5th consecutive
stall on this lane). I decomposed it into the (a)–(e) / (i)–(iii) blueprint sentences and
attacked each atomically.

## Sentence-by-sentence

### Step (a) `restrictScalarsId_map` strip → already committed (iter-264)
- **Result:** RESOLVED (pre-existing) — `rw [restrictScalarsId_map]`.

### Step (b) split merged sheaf composite under `forget.map` → already committed (iter-264)
- **Result:** RESOLVED (pre-existing) — `conv_rhs => rw [Functor.map_comp]` + `forget_map_pushforward_map` + `rw [Functor.map_comp]`.

### Step (i) "distribute the inner `forget.map (R1 ≫ R5 ≫ δ_pre)`" → committed THIS iter
- **Result:** RESOLVED — `conv_rhs => rw [Functor.map_comp, Functor.map_comp]`.
- Verified (via `lean_multi_attempt` at the sorry) that this is RHS-confined: the LHS unit
  `pushforward.map (sheafAdj_Z.unit _)` is untouched. The RHS inner tail is now the explicit
  `forget.map R1 ≫ forget.map R5 ≫ forget.map (a_Z.map δ_pre)`, exposing R1 for recovery.
- **This is a genuine proof-body advance** (one more closed step in the tail), now in the file.

### Step (ii) "recover R1/R5 as B_f/B_h units" — the `conjugateEquiv_whiskerRight` device → DE-RISKED + scaffolded
- **Result:** PARTIAL (device verified to elaborate; consumption into the goal still open).
- **What landed:** committed `have hwr := CategoryTheory.conjugateEquiv_whiskerRight A₁ A₂ adj_h τ`
  with the project's exact adjunctions:
  - `A₁ = B_f = (PresheafOfModules.pullbackPushforwardAdjunction φ'_f).comp (sheafAdj_Y)`
  - `A₂ = A_f = (sheafAdj_X).comp (SheafOfModules.pullbackPushforwardAdjunction f.toRingCatSheafHom)`
  - `adj_h = Scheme.Modules.pullbackPushforwardAdjunction h`
  - `τ = (SheafOfModules.sheafificationCompPullback f.toRingCatSheafHom).hom`
- **KEY FINDING (de-risks the analogist's "low–medium porting cost"):** `hwr` **typechecks at the
  project's types** — the namespace is `CategoryTheory.conjugateEquiv_whiskerRight` (NOT
  `CategoryTheory.Adjunction.…`, which fails "unknown constant"). Its type is exactly
  `conjugateEquiv (B_f.comp adj_h) (A_f.comp adj_h) (whiskerRight τ (pullback h)) =
   whiskerLeft (pushforward h) (conjugateEquiv B_f A_f τ)`.
  After `whiskerRight_app`, the LHS is the conjugate of the goal's R1 factor
  `(pullback h).map ((sheafCompPb f).hom.app P)`.
- **CORRECTION to the analogist's recipe (`analogies/d3-mate271.md`):** the recipe said the wrapping
  is `whiskerLeft (pullback h) g`, hence `conjugateEquiv_whiskerLeft`. That is WRONG: the goal factor
  is `(pullback h).map (g.app P)` = `(whiskerRight g (pullback h)).app P` (whiskerLeft would give
  `g.app ((pullback h).obj P)`). The correct device is **`conjugateEquiv_whiskerRight`** (Mates.lean:536),
  which I verified applies; `conjugateEquiv_whiskerLeft` does NOT match.

### Step (iii) "slide pushforwardComp.hom past + collapse to B_{h≫f}.unit" → OPEN
- **Result:** sorry (the genuine residual).
- **Exact blocker:** `hwr` is a CONJUGATE-level identity (between the composite right adjoints). The
  raw goal does NOT yet contain a conjugate — it has the bare whiskered natTrans applied at `P`. To
  consume `hwr` one must first transpose the whole tail through the `(h≫f)`-composite adjunction
  `homEquiv.injective`. The LHS-only re-transpose is circular (re-folds the R0-peel — flagged in-file).
  The non-circular route is the analogist's `surjective`/`injective` reduction of
  `leftAdjointCompNatTrans_assoc` (CompositionIso.lean:155), landing the cocycle on the trivial
  pushforward side, after which `hwr` + `unit_conjugateEquiv` (Mates.lean:294) + `conjugateEquiv_comp`
  (Mates.lean:338) collapse it. Estimated ~40–60 LOC; **the device is no longer the blocker** — the
  remaining work is the transposition-setup + cocycle collapse.

## Assembly (`sheafificationCompPullback_comp_tail`)
- References committed: `restrictScalarsId_map`, `forget_map_pushforward_map`, step-(i) distribution,
  `hwr` (the conjugateEquiv_whiskerRight device).
- Compiles with one scoped `sorry` after `hwr` (step (iii) residual).

## Summary
- **Sentences:** (a),(b),(i) RESOLVED (3 closed; (a)/(b) were pre-existing, (i) is new this iter);
  (ii) PARTIAL (device verified + scaffolded); (iii) open.
- **Sorry count (this file): 3 → 3** (unchanged — the tail sorry remains; step (i) advanced the body
  by one closed tactic and `hwr` is in place).
- **Open sub-lemma & exact reason:** `sheafificationCompPullback_comp_tail` step (iii) — needs the
  transposition setup (`leftAdjointCompNatTrans_assoc` surjective/injective reduction) to expose a
  conjugate before `hwr` can be `rw`'d in. `hwr` itself is closed and correctly typed.

## Why I stopped
- **Real progress:** step (i) distribution committed into the proof body (1 new closed tactic);
  `conjugateEquiv_whiskerRight` device confirmed to elaborate at the project's adjunction types and
  committed as `hwr`. This resolves the analogist's open "porting cost" question (it works) AND
  corrects the analogist's whiskerLeft↛whiskerRight error.
- **Partial progress / open:** the tail sorry (step (iii)) — blocker is that `hwr` is conjugate-level
  and the goal is left-adjoint-level, so a non-circular transposition (CompositionIso.lean:155 route)
  must precede consuming it. Not attempted to completion (the ~40–60 LOC two-layer cocycle collapse
  exceeds a fine-grained budget); the precise next step is documented in-file and above.
- **Recommendation for next pass:** target step (iii) with directive "transpose the whole tail via
  `(h≫f)`-composite `homEquiv.injective` using the CompositionIso `leftAdjointCompNatTrans_assoc`
  surjective/injective reduction, then `rw [hwr]` + `unit_conjugateEquiv` + `conjugateEquiv_comp`."
  The device (`hwr`) is already in place and verified.

## Note for blueprint/review
- No declarations newly closed → no `\leanok` changes warranted for the tail.
- The analogist note `analogies/d3-mate271.md` should be corrected: the device is
  `conjugateEquiv_whiskerRight` (Mates.lean:536), not `conjugateEquiv_whiskerLeft` (Mates.lean:525).
